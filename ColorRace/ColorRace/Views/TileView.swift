//
//  TileView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 19/08/23.
//

import SwiftUI

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

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView()
    }
}
