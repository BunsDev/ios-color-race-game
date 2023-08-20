//
//  TileContainerView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 19/08/23.
//

import SwiftUI

struct TileContainerView: View {
    @State private var grid: [[Tile]] = []
    
    var body: some View {
        GeometryReader { geometry in
            let tileSize = geometry.size.width / (UIDevice.current.userInterfaceIdiom == .pad ? 10 : 100)
            
            VStack(spacing: 0) {
                ForEach(0..<10, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<10, id: \.self) { column in
                            Tile(width: tileSize, height: tileSize, isAnimating: self.grid[row][column].isAnimating, color: self.grid[row][column].color)
                                .onTapGesture {
                                    self.startRandomAnimation()
                                }
                        }
                    }
                }
            }
        }
        .onAppear() {
            self.initializeGrid()
            self.startRandomAnimation()
        }
    }
    
    func initializeGrid() {
        let colors: [Color] = [.red, .blue, .orange, .yellow, .white]
        grid = (0..<10).map { _ in
            (0..<10).map { _ in
                Tile(width: 0, height: 0, color: colors.randomElement()!.opacity(0.2))
            }
        }
    }
    
    func startRandomAnimation() {
        let randomRow = Int.random(in: 0..<10)
        let randomColumn = Int.random(in: 0..<10)
        
        withAnimation(Animation.easeInOut(duration: 1.0)) {
            grid[randomRow][randomColumn].isAnimating = true
            grid[randomRow][randomColumn].color = grid[randomRow][randomColumn].color.opacity(1.0)
            grid[randomRow][randomColumn].xOffset = UIScreen.main.bounds.width / 2 > grid[randomRow][randomColumn].width * CGFloat(10) ? -1 : 1
            grid[randomRow][randomColumn].rotationAngle = grid[randomRow][randomColumn].xOffset > 0 ? -15 : 15
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(Animation.easeInOut(duration: 1.0)) {
                grid[randomRow][randomColumn].isAnimating = false
                grid[randomRow][randomColumn].color = grid[randomRow][randomColumn].color.opacity(0.2)
                grid[randomRow][randomColumn].xOffset = 0
                grid[randomRow][randomColumn].rotationAngle = 0
            }
        }
    }
}

struct TileContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TileContainerView()
    }
}
