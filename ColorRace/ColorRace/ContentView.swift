//
//  ContentView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 16/08/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<3) { _ in
                HStack(spacing: 10) {
                    ForEach(0..<3) { _ in
                        TileView()
                    }
                }
            }
        }
        .padding()
    }
}

struct TileView: View {
    @State private var colorIndex = 0
    private let colors: [Color] = [.white, .red, .green, .blue]
    
    var body: some View {
        Rectangle()
            .fill(colors[colorIndex])
            .frame(width: 100, height: 100)
            .border(.black, width: 2.0)
            .onTapGesture {
                colorIndex = (colorIndex + 1) % colors.count
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
