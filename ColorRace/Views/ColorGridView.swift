//
//  ColorGridView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 22/08/23.
//

import SwiftUI
import UIKit

struct ColorGridView: View {
    let colors: [[UIColor]]
    let displayDefault: Bool
    
    private let spacing = 2.0
    private let shadowRadius = 50.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: spacing) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<3, id: \.self) { column in
                            RoundedRectangle(cornerRadius: 2, style: .continuous)
                                .fill(Color(uiColor: color(row: row, col: column)))
                                .frame(width: (geometry.size.width - (spacing*2)) / 3, height: (geometry.size.width - (spacing*2)) / 3)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                                        .stroke(Color.black, lineWidth: 1.0)
                                }
                        }
                    }
                }
            }
            // .shadow(radius: shadowRadius)
        }
    }
    
    private func color(row: Int, col: Int) -> UIColor {
        guard displayDefault else {
            return colors[row][col]
        }
        return GameColors.white()
    }
}

struct ColorGridView_Previews: PreviewProvider {
    static var previews: some View {
        ColorGridView(colors: [[.red, .red, .red],[.blue, .blue, .blue], [.orange, .orange, .orange]],
                      displayDefault: true)
    }
}
