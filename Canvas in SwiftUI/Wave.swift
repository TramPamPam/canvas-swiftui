//
//  Wave.swift
//  Canvas in SwiftUI
//
//  Created by Oleksandr on 09.01.2022.
//

import SwiftUI

struct Wave: View {
    var body: some View {
        let amplitude = 0.05   // Amplitude of sine wave is 5% of view height

        Canvas { context, size in
            let origin = CGPoint(x: 0, y: size.height * 0.50)

            let rect = CGRect(origin: origin, size: size)

            // Path
            var path = Path.init(CGRect(origin: origin, size: size))
            path.move(to: origin)

            for angle in stride(from: 0, through: 360.0, by: 0.5) {
                let x = angle/360.0 * size.width
                let y = origin.y - sin(angle/180.0 * .pi) * size.height * amplitude
                path.addLine(to: CGPoint(x: x, y: y))
            }

            // Stroke path
            context.stroke(path, with: .linearGradient(
                Gradient(colors: [.purple, .blue]),
                startPoint: .zero,
                endPoint: CGPoint(x: size.width, y: 0)
            ))

            // Gradient
            let gradient = Gradient(colors: [.blue, .purple])
            let from = rect.origin
            let to = CGPoint(x: rect.width + from.x, y: from.y)

            // Fill path
            context.fill(path, with: .linearGradient(gradient,
                                                     startPoint: from,
                                                     endPoint: to))
        }
    }
}

struct Wave_Previews: PreviewProvider {
    static var previews: some View {
        Wave()
    }
}

struct WaveView: View {
    @State private var phase = 0.0

    let colors: [Color] = [.red, .green, .black, .yellow, .purple]
    var body: some View {
        ZStack {
            ForEach(0..<colors.count) { i in
                let str = Double(i * Int.random(in: 1..<10))
                let fr = Double(i + Int.random(in: 0...1))
                WaveShape(strength: str,
                          frequency: fr,
                          phase: self.phase
                )
                    .stroke(colors[i], lineWidth: Double(i+2))
                    .offset(y: CGFloat(i) * 10)                
            }
        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                self.phase = .pi * 2
            }
        }
    }
}

struct WaveShape: Shape {
    static var role: ShapeRole {
        .separator
    }
    // allow SwiftUI to animate the wave phase
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }

    // how high our waves should be
    var strength: Double

    // how frequent our waves should be
    var frequency: Double

    // how much to offset our waves horizontally
    var phase: Double

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()

        // calculate some important values up front
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let oneOverMidWidth = 1 / midWidth

        // split our total width up based on the frequency
        let wavelength = width / frequency

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
            let sine = sin(relativeX + phase)

            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = parabola * strength * sine + midHeight

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return Path(path.cgPath)
    }
}
