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
            } else {
                CardBackView(card: card)
            }
        }
        .frame(width: card.width, height: card.height)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: CardStore.standard)
    }
}
