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
    private let predefinedColors: [UIColor] = [.red, .blue, .orange, .yellow, .white]
    let colors: [[UIColor]]// = [.red, .blue, .orange, .yellow, .white]
    @State private var randomize: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { column in
                            Rectangle()
                                .fill(Color(colors[row][column]))
//                                .fill(colors.randomElement()!)
                                .border(Color.black, width: cardType == .small ? 0.3 : 1)
                                .frame(width: geometry.size.width/3, height: geometry.size.width/3)
                        }
                    }
                }
            }
        }
    }
}

struct ColorGridView_Previews: PreviewProvider {
    static var previews: some View {
        ColorGridView(cardType: .small, colors: [[.red, .red, .red],[.blue, .blue, .blue], [.orange, .orange, .orange]])
    }
}
