//
//  ClockView.swift
//  Canvas in SwiftUI
//
//  Created by Oleksandr on 09.01.2022.
//

// Author: SwiftUI-Lab (www.swiftui-lab.com)
// Description: This code is part of the "Advanced SwiftUI Animations - Part 5"
// Article: https://swiftui-lab.com/swiftui-animations-part5/

import SwiftUI

struct ClockView: View {
    var body: some View {

        GeometryReader { proxy in
            HStack(spacing: 0) {
                Spacer()

                ZStack {
                    ClockFaceCanvas()

                    TimelineView(.animation(minimumInterval: 0.06)) { timeline in
                        ClockHandsCanvas(date: timeline.date)
                    }
                } // we make sure the Canvas is always a square size
                .frame(width: min(proxy.size.width, proxy.size.height),
                       height: min(proxy.size.width, proxy.size.height))

                Spacer()
            }
        }
        .padding(20)
    }
}

struct ClockFaceCanvas: View {
    var body: some View {
        Canvas { context, size in
            drawFace(context: context, size: size)
            drawTicks(context: context, size: size)
            drawNumbers(context: context, size: size)
            drawBrand(context: context, size: size)
        }
    }

    func drawFace(context: GraphicsContext, size: CGSize) {

        let rect = CGRect(origin: .zero, size: size).insetBy(dx: size.width * 0.04, dy: size.width * 0.04)

        let circle_path = Circle().path(in: rect)

        // Border
        context.stroke(circle_path,
                       with: .linearGradient(Gradient(colors: [.gray, .black]),
                                             startPoint: .zero,
                                             endPoint: CGPoint(x: size.width, y: size.height)),
                       lineWidth: size.width * 0.08)

        // Background
        let gradient = Gradient(stops: [.init(color: .white, location: 0),
                                        .init(color: .white, location: 0.9),
                                        .init(color: .gray, location: 0.95),
                                        .init(color: .black, location: 1.05)])

        context.fill(circle_path, with: .radialGradient(gradient,
                                                   center: CGPoint(x: size.width/2, y: size.height/2),
                                                   startRadius: 0,
                                                   endRadius: size.width/2 - size.width/2 * 0.04))
    }

    func drawTicks(context: GraphicsContext, size: CGSize) {
        let thin_width = size.width * 0.004
        let thick_width = size.width * 0.012

        let thin = Path(CGRect(origin: CGPoint(x: -thin_width/2, y: size.height * 0.41),
                               size: CGSize(width: thin_width, height: size.height * 0.025)))

        let thick = Path(CGRect(origin: CGPoint(x: -thick_width/2, y: size.height * 0.40),
                                size: CGSize(width: thick_width, height: size.height * 0.038)))


        for tick in 0...59 {
            var context = context

            context.translateBy(x: size.width/2.0, y: size.height/2.0)
            context.rotate(by: .degrees(Double(tick) * (360 / 60) + 180))
            context.fill(tick % 5 == 0 ? thick : thin, with: .color(.black))
        }
    }

    func drawNumbers(context: GraphicsContext, size: CGSize) {
        for h in 1...12 {
            let hour = Double(h)

            let angle: Angle = .degrees(360 / (12/(12-hour)) + 180)

            let number = Text("\(h)")
                .font(.custom("Futura", size: size.width * 0.1))
                .foregroundColor(.black)

            let offset = CGPoint(x: size.width/2 + sin(Double(angle.radians)) * size.width * 0.33,
                                 y: size.height/2 + cos(angle.radians) * size.width * 0.33)

            context.draw(number, at: offset, anchor: .center)
        }
    }

    func drawBrand(context: GraphicsContext, size: CGSize) {

        let location = CGPoint(x: size.width/2, y: size.height * 0.65)

        let text = Text("SwiftUI-Lab")
            .font(.custom("Futura Bold", size: size.width * 0.03))
            .foregroundColor(.black)

        context.draw(text, at: location, anchor: .center)
    }
}

struct ClockHandsCanvas: View {
    let calendar =  Calendar.current
    let date: Date

    var body: some View {
        Canvas { context, size in
            drawHands(context: context, size: size, date: date)
        }
    }

    func drawHands(context: GraphicsContext, size: CGSize, date: Date) {
        // Get date components.
        let components = calendar.dateComponents(in: TimeZone.current, from: date)

        // The hour component is kept in the 0-11 range. For example, for 15:00:00, h is 3
        let h = Double(components.hour! % 12)

        // The minute component is in the 0-59 range
        let m = Double(components.minute!)

        // Nanoseconds are converted into seconds and added to the `s` variable.
        let s = Double(components.second!) + Double(components.nanosecond!) / 1000000 / 1000

        // Angles for each clock hand. Angles include fractions of hour, minute and second.
        // For example for 14:30:00, the angle of the hour hand, will be exactly in the middle
        // between the 2 and 3 hour positions
        let s_angle = s / 60 * 360
        let m_angle = (m + (s_angle / 360)) / 60 * 360
        let h_angle = (h + (m_angle / 360)) / 12 * 360

        // Canvas center point
        let midpoint = CGPoint(x: size.width/2, y: size.height/2)

        // Hour
        context.drawLayer { context in
            let w = size.width * 0.016 // clock hand width
            let o: CGFloat = size.width * 0.075 // clock hand offset from center

            let path = Path(CGRect(origin: CGPoint(x: -w/2, y: -o),
                                   size: CGSize(width: w,
                                                height: size.height/2.0 * 0.58 + o)))

            context.translateBy(x: size.width/2.0, y: size.height/2.0)
            context.rotate(by: .degrees(h_angle + 180))
            context.addFilter(.shadow(radius: 3))
            context.fill(path, with: .color(.black))
        }

        // Minute
        context.drawLayer { context in
            let w = size.width * 0.016 // clock hand width
            let o: CGFloat = size.width * 0.075 // clock hand offset from center

            let path = Path(CGRect(origin: CGPoint(x: -w/2, y: -o),
                                   size: CGSize(width: w,
                                                height: size.height/2.0 * 0.76 + o)))

            context.translateBy(x: size.width/2.0, y: size.height/2.0)
            context.rotate(by: .degrees(m_angle + 180))
            context.addFilter(.shadow(radius: 3))
            context.fill(path, with: .color(.black))
        }

        // Center black dot
        let dot1_d = size.width * 0.048 // dot diameter
        let dot1_s = CGSize(width: dot1_d, height: dot1_d) // dot size
        let dot1_o = CGPoint(x: midpoint.x - dot1_d/2, y: midpoint.y - dot1_d/2) // dot origin
        let dot1_p = Circle().path(in: CGRect(origin: dot1_o, size: dot1_s)) // dot path
        context.fill(dot1_p, with: .color(.black))

        // Second
        context.drawLayer { context in
            let w = size.width * 0.008 // clock hand width
            let o: CGFloat = size.width * 0.15 // clock hand offset from center

            let path = Path(CGRect(origin: CGPoint(x: -w/2, y: -o),
                                   size: CGSize(width: w,
                                                height: size.height/2.0 * 0.7 + o)))

            context.translateBy(x: size.width/2.0, y: size.height/2.0)
            context.rotate(by: .degrees(s_angle + 180))
            context.addFilter(.shadow(radius: 3))
            context.fill(path, with: .color(.red))
        }

        // Center gray dot
        let dot2_d = size.width * 0.02 // dot diameter
        let dot2_s = CGSize(width: dot2_d, height: dot2_d) // dot size
        let dot2_o = CGPoint(x: midpoint.x - dot2_d/2, y: midpoint.y - dot2_d/2) // dot origin
        let dot2_p = Circle().path(in: CGRect(origin: dot2_o, size: dot2_s)) // dot path
        context.fill(dot2_p, with: .color(.gray))
    }
}
