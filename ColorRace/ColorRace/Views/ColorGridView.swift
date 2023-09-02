//
//  ColorGridView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 22/08/23.
//

import SwiftUI
import UIKit

struct ColorGridView: View {
    let cardType: CardType
    let colors: [[UIColor]]
    
    private let defaultBoardColor: Color = .white
    private let predefinedColors: [UIColor] = [.red, .blue, .orange, .yellow, .white]
    @State private var randomize: Bool = false
    @State private var displayDefault: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { column in
                            Rectangle()
                                .fill(fillColor(row: row, col: column))
                                .border(Color.black, width: cardType == .small ? 0.3 : 1)
                                .frame(width: geometry.size.width/3, height: geometry.size.width/3)
                        }
                    }
                }
            }
        }
    }
    
    private func fillColor(row: Int, col: Int) -> Color {
        guard displayDefault else {
            if randomize, let color = predefinedColors.randomElement() {
                return Color(uiColor: color)
            } else {
                return Color(colors[row][col])
            }
        }
        return .white
    }
}

struct ColorGridView_Previews: PreviewProvider {
    static var previews: some View {
        ColorGridView(cardType: .small, colors: [[.red, .red, .red],[.blue, .blue, .blue], [.orange, .orange, .orange]])
    }
}
