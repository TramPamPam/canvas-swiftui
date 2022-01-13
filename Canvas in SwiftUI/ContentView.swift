//
//  ContentView.swift
//  Canvas in SwiftUI
//
//  Created by Oleksandr on 09.01.2022.
//

import SwiftUI

enum Example: String {
   static var values: [Self] { [.matrix, .clock, .wave, .waveShape, .waveAnimatedShape] }
    case matrix, clock, wave, waveShape, waveAnimatedShape
}

struct ContentView: View {
    
    @State private var isPlaying = false

    private var values: [Example] = Example.values

    var body: some View {
        content.preferredColorScheme(.dark)
    }


    var content: some View {
        NavigationView {
            List {
                ForEach(values, id: \.self) { value in
                    switch (value) {
                    case .matrix:
                        NavigationLink(destination: DigitalRain()) {
                            Text("\(value.rawValue)")
                                .foregroundStyle(.primary)
                        }
                    case .clock:
                        NavigationLink(destination: ClockView()) {
                            Text("\(value.rawValue)")
                                .foregroundStyle(.primary)
                        }
                    case .wave:
                        NavigationLink(
                            destination: Wave()
                        ) {
                            Text("\(value.rawValue)")
                                .foregroundStyle(.primary)
                        }
                    case .waveShape:
                        NavigationLink(
                            destination: WaveShape(strength: 50, frequency: 10, phase: 0.5)

                        ) {
                            Text("\(value.rawValue)")
                                .foregroundStyle(.primary)
                        }
                    case .waveAnimatedShape:
                        NavigationLink(
                            destination: WaveView()
                        ) {
                            Text("\(value.rawValue)")
                                .foregroundStyle(.primary)
                        }


                    default:
                        Text("Unhandled animation \(value.rawValue)")
                            .foregroundStyle(.secondary)
                    }

                }
            }
            .navigationTitle("Canvas animations")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
