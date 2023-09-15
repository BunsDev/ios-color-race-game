//
//  CardFaceView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 21/08/23.
//

import SwiftUI

struct CardFaceView: View {
    @State var cardLayout: CardLayout
    @State var cardFace: CardFaceDrawable
    @Binding var degree: Double
    @Binding var opacity: Double
    private let colorGridWidth = 50.0
    private let colorGridHeight = 50.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardLayout.cornerRadius)
                .strokeBorder(cardLayout.borderColor, lineWidth: cardLayout.borderWidth)
                .background(
                    RoundedRectangle(cornerRadius: cardLayout.cornerRadius).fill(cardLayout.color)
                )
                .frame(width: cardLayout.width, height: cardLayout.height)
                .overlay(alignment: .topLeading) {
                    topDetailView()
                }
                .overlay(alignment: .bottomTrailing) {
                    bottomDetailView()
                }
                .opacity(opacity)
                .overlay(alignment: .center) {
                    ColorGridView(colors: cardFace.colors, displayDefault: false)
                        .frame(width: colorGridWidth, height: colorGridHeight)
                }
        }
        .frame(width: cardLayout.width, height: cardLayout.height)
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
    
    @ViewBuilder private func topDetailView() -> some View {
        rankView(rank: cardFace.letter, symbol: cardFace.suit)
    }

    @ViewBuilder private func bottomDetailView() -> some View {
        rankView(rank: cardFace.letter, symbol: cardFace.suit, rotated: true)
    }
    
    @ViewBuilder private func rankView(rank: String, symbol: String,  rotated: Bool = false) -> some View {
        HStack {
            if rotated {
                VStack {
                    Image(systemName: symbol)
                        .font(GameUx.fontWithSize(10))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                    Text(rank)
                        .font(GameUx.fontWithSize(20))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                }.padding(5)
            } else {
                VStack {
                    Text(rank)
                        .font(GameUx.fontWithSize(20))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                    Image(systemName: symbol)
                        .font(GameUx.fontWithSize(10))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                }.padding(5)
            }
        }
        .foregroundColor(.black)
    }
}

struct CardFaceView_Previews: PreviewProvider {
    static var previews: some View {
        CardStore.mediumCardFaceView
    }
}
