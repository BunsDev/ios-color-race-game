//
//  CardView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 19/08/23.
//

import SwiftUI

struct CardView: View {
    @State var card: Card

    var body: some View {
        VStack {
            if card.isFaceUp {
                CardFaceView(card: card)
                    .frame(width: card.width, height: card.height)
            } else {
                CardBackView(card: card)
                    .frame(width: card.width, height: card.height)
            }
        }
    }
    
    
}

struct GridCardSymbols: View {
    private let cardSymbols = CardDetail.symbols
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<2, id: \.self) { _ in
                HStack(spacing: 0) {
                    ForEach(cardSymbols, id: \.self) { symbol in
                        Text(symbol)
                            .font(.system(size: 5))
                            .padding()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ColorGridView: View {
    private let colors: [Color] = [.red, .blue, .orange, .yellow, .white]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { column in
                        Rectangle()
                            .fill(colors.randomElement()!)
                            .border(Color.black, width: 1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: CardStore.standard)
    }
}
