//
//  WaveShape.swift
//  Canvas in SwiftUI
//
//  Created by Oleksandr Bezpalchuk on 14.01.2022.
//

import SwiftUI

struct WaveShape: Shape {
    static var role: ShapeRole {
        .stroke
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
