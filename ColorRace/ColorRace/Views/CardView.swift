//
//  CardView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 19/08/23.
//

import SwiftUI

// TODO: Update Card view to take card and apply appropriate sizing
struct CardView: View {
    let color: Color
    @State private var isFront = true
    private let randomCardRank = Card.cardRanks.randomElement()!
    private let randomCardSymbol = Card.cardSymbols.randomElement()!
    
    var body: some View {
        VStack {
            if isFront {
                faceView(rank: randomCardRank, symbol: randomCardSymbol)
            } else {
                backView()
            }
        }
        .background(color)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 2)
        )
    }
    
    private func faceView(rank: String, symbol: String) -> some View {
        return VStack {
            rankView(rank: rank, symbol: symbol)
            ColorGridView()
                .padding()
            rankView(rank: rank, symbol: symbol, rotated: true)
        }
    }
    
    private func rankView(rank: String, symbol: String,  rotated: Bool = false) -> some View {
        return VStack {
            VStack(alignment: .leading) {
                HStack {
                    if rotated {
                        Spacer()
                    }
                    Text(" \(rank)")
                        .font(.system(size: 20))
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
                        .font(.system(size: 20))
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
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .background(Color.clear)
                .padding()
        }
    }
}

struct GridCardSymbols: View {
    private let cardSymbols = Card.cardSymbols
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<2, id: \.self) { _ in
                HStack(spacing: 0) {
                    ForEach(cardSymbols, id: \.self) { symbol in
                        Text(symbol)
                            .font(.system(size: 8))
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
        CardView(color: .white)
            .frame(width: Card.standard.width, height: Card.standard.height)
    }
}
