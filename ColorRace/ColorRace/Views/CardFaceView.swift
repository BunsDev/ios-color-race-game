//
//  CardFaceView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 21/08/23.
//

import SwiftUI

struct CardFaceView: View {
    @State var card: Card
    let cornerRadius: CGFloat = 15.0
    
    var body: some View {
        GeometryReader { geometry in
            if card.type == .small {
                miniFaceView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .border(.orange, width: 1)
            } else {
                fullFaceView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(card.faceColor)
                    .cornerRadius(card.type == .medium ? 5 : 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: card.type == .medium ? 5 : 15)
                            .stroke(Color.black, lineWidth: card.type == .medium ? 1 : 2)
                    )
            }
        }
    }
    
    private func fullFaceView() -> some View {
        return VStack {
            topDetailView()
            ColorGridView(cardType: card.type)
                .padding()
            bottomDetailView()
        }
    }
    
    private func miniFaceView() -> some View {
        ColorGridView(cardType: card.type)
    }
    
    private func topDetailView() -> some View {
        return HStack {
            rankView(rank: card.rank, symbol: card.symbol)
            Spacer()
        }
    }

    private func bottomDetailView() -> some View {
        return HStack {
            Spacer()
            rankView(rank: card.rank, symbol: card.symbol, rotated: true)
        }
    }
    
    private func rankView(rank: String, symbol: String,  rotated: Bool = false) -> some View {
        return HStack {
            if rotated {
                VStack {
                    Text(symbol)
                        .font(.system(size: card.faceFontSize))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                    Text(rank)
                        .font(.system(size: card.faceFontSize))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                }.padding(0)
            } else {
                VStack {
                    Text(rank)
                        .font(.system(size: card.faceFontSize))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                    Text(symbol)
                        .font(.system(size: card.faceFontSize))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                }.padding(0)
            }
        }.padding(0)
    }
}

struct CardFaceView_Previews: PreviewProvider {
    static var previews: some View {
        CardFaceView(card: CardStore.standard)
    }
}
