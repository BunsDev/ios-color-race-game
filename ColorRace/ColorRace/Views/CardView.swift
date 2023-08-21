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
                faceView()
            } else {
                backView()
            }
        }
        .frame(width: card.width, height: card.height)
        .background(card.isFaceUp ? card.faceColor : card.backColor)
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
    
    private func backView() -> some View {
        return ZStack {
            GridCardSymbols()
            
            Text("Color Race")
                .font(.system(size: card.backFontSize, weight: .bold))
                .foregroundColor(.white)
                .background(Color.clear)
                .padding()
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
                            .border(Color.black, width: 1.0)
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
//            .frame(width: CardStore.standard.width, height: CardStore.standard.height)
    }
}
