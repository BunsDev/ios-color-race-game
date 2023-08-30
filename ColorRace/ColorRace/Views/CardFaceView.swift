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
    
    var body: some View {
        GeometryReader { geometry in
            if cardFace.type == .small {
                miniFaceView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .border(cardLayout.borderColor, width: cardLayout.borderWidth)
            } else {
                fullFaceView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(cardLayout.color)
                    .cornerRadius(cardLayout.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: cardLayout.cornerRadius)
                            .stroke(cardLayout.borderColor, lineWidth: cardLayout.borderWidth)
                    )
            }
        }
    }
    
    private func fullFaceView() -> some View {
        return VStack {
            topDetailView()
            ColorGridView(cardType: cardFace.type)
                .padding()
            bottomDetailView()
        }
    }
    
    private func miniFaceView() -> some View {
        ColorGridView(cardType: cardFace.type)
    }
    
    private func topDetailView() -> some View {
        return HStack {
            rankView(rank: cardFace.letter, symbol: cardFace.suit)
            Spacer()
        }
    }

    private func bottomDetailView() -> some View {
        return HStack {
            Spacer()
            rankView(rank: cardFace.letter, symbol: cardFace.suit, rotated: true)
        }
    }
    
    private func rankView(rank: String, symbol: String,  rotated: Bool = false) -> some View {
        return HStack {
            if rotated {
                VStack {
                    Text(symbol)
                        .font(.system(size: cardFace.fontSize))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                    Text(rank)
                        .font(.system(size: cardFace.fontSize))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                }.padding(0)
            } else {
                VStack {
                    Text(rank)
                        .font(.system(size: cardFace.fontSize))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                    Text(symbol)
                        .font(.system(size: cardFace.fontSize))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                }.padding(0)
            }
        }.padding(0)
    }
}

struct CardFaceView_Previews: PreviewProvider {
    static var previews: some View {
        CardStore.mediumCardFaceView
    }
}
