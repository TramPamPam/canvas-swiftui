//
//  Wave.swift
//  Canvas in SwiftUI
//
//  Created by Oleksandr on 09.01.2022.
//

import SwiftUI

struct Wave: View {
    var body: some View {
        
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let origin = CGPoint(x: 0, y: size.height * 0.50)

                let rect = CGRect(origin: origin, size: size)

                // Path
                var path = Path.init(CGRect(origin: origin, size: size))
                path.move(to: origin)

                let strength = abs(timeline.date.timeIntervalSince1970.remainder(dividingBy: 0x10)) * 10
                
                for angle in stride(from: 0, through: 360.0, by: 0.5) {
                    path = phase(angle: angle / .pi, in: rect, strength: strength)
                }

                // Gradient
                let gradient = Gradient(colors: [.blue, .purple])
                let from = rect.origin
                let to = CGPoint(x: rect.width + from.x, y: from.y)

                // Fill path
//                context.fill(path, with: .linearGradient(gradient,
//                                                         startPoint: from,
//                                                         endPoint: to))

                // Stroke path
                context.stroke(path, with: .linearGradient(gradient,
                                                         startPoint: from,
                                                         endPoint: to))
            }
        }

    }
    
    func phase(angle: Double, in rect: CGRect, strength: Double) -> Path {
        let path = UIBezierPath()

        // calculate some important values up front
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let oneOverMidWidth = 1 / midWidth

        // split our total width up based on the frequency
        let wavelength = width / 5

        // start at the left center
        path.move(to: CGPoint(x: 0, y: midHeight))

        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width, by: 1) {
            // find our current position relative to the wavelength
            let relativeX = x / wavelength

            // find how far we are from the horizontal center
            let distanceFromMidWidth = x - midWidth

            // bring that into the range of -1 to 1
            let normalDistance = oneOverMidWidth * distanceFromMidWidth

            let parabola = -(normalDistance * normalDistance) + 1

            // calculate the sine of that position, adding our phase offset
            let sine = sin(relativeX + angle)

            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = parabola * strength * sine + midHeight

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return Path(path.cgPath)
    }
    
}

struct Wave_Previews: PreviewProvider {
    static var previews: some View {
        Wave()
    }
}

