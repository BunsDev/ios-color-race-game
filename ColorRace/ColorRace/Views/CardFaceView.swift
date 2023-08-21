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
        faceView()
            .background(card.faceColor)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 2)
            )
    }
    
    private func faceView() -> some View {
        return VStack {
            rankView(rank: card.rank, symbol: card.symbol)
            ColorGridView()
                .padding()
            rankView(rank: card.rank, symbol: card.symbol, rotated: true)
        }
    }
    
    private func rankView(rank: String, symbol: String,  rotated: Bool = false) -> some View {
        return VStack {
            VStack(alignment: .leading) {
                HStack {
                    if rotated {
                        Spacer()
                    }
                    Text(" " + rank)
                        .font(.system(size: card.faceFontSize))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                    if !rotated {
                        Spacer()
                    }
                }
                HStack {
                    if rotated {
                        Spacer()
                    }
                    Text(symbol)
                        .font(.system(size: card.faceFontSize))
                        .rotationEffect(.degrees(rotated ? 180 : 0))
                    if !rotated {
                        Spacer()
                    }
                }
            }
        }
    }
}

struct CardFaceView_Previews: PreviewProvider {
    static var previews: some View {
        CardFaceView(card: CardStore.standard)
    }
}
