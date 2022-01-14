//
//  WaveView.swift
//  Canvas in SwiftUI
//
//  Created by Oleksandr Bezpalchuk on 14.01.2022.
//

import SwiftUI

struct WaveView: View {
    @State private var phase = 0.0

    let colors: [Color] = [.red, .green, .black, .yellow, .purple]
    var body: some View {
        ZStack {
            ForEach(0..<colors.count) { i in
                
//                WaveShape(strength: 5,
//                          frequency: Double(i),
//                          phase: self.phase
//                )
//
                let str = Double(i * Int.random(in: 1..<10))
                let fr = Double(i + Int.random(in: 0...1))
                WaveShape(strength: str,
                          frequency: fr,
                          phase: self.phase
                )
                    .fill(colors[i]) // can be .stroke(colors[i], lineWidth: Double(i + 2))
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
