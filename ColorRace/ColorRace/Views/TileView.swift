//
//  TileView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 19/08/23.
//

import SwiftUI

struct Tile: View {
    let width: CGFloat
    let height: CGFloat
    @State var isAnimating: Bool = false
    @State var color: Color
    @State var xOffset: CGFloat = 0
    @State var rotationAngle: Double = 0
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundColor(color)
            .scaleEffect(isAnimating ? 1.25 : 1.0)
            .rotation3DEffect(
                .degrees(isAnimating ? rotationAngle : 0),
                axis: (x: isAnimating ? xOffset : 0, y: 0, z: 0)
            )
            .animation(.easeInOut(duration: 1.0))
            .onAppear() {
                if isAnimating {
                    // Determine the side of the screen (left or right)
                    xOffset = UIScreen.main.bounds.width / 2 > width * CGFloat(10) ? -1 : 1
                    // Rotate the tile based on the side
                    rotationAngle = xOffset > 0 ? -15 : 15
                }
            }
    }
}


struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        Tile(width: 100, height: 100, color: .orange)
    }
}
