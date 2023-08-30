//
//  CardView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 19/08/23.
//

import SwiftUI

struct CardView: View {
    @State var cardDesign: CardDesign

    var body: some View {
        VStack {
            switch cardDesign.renderer {
            case .face(let cardDrawable):
                CardFaceView(cardLayout: cardDesign.layout, cardFace: cardDrawable)
            case .back(let cardDrawable):
                CardBackView(cardLayout: cardDesign.layout, cardBack: cardDrawable)
            }
        }
        .frame(width: cardDesign.layout.width, height: cardDesign.layout.height)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let standardCardLayout = CardLayout(width: 200, height: 330, color: .white, cornerRadius: 15, borderWidth: 2, borderColor: .black)
        let standardCardFace = CardFace(letter: "10", suit: "♣️", fontSize: 20, type: .standard)
        let standardCardBack = CardBack(text: "CR", font: GameUx.titleFont(), textColor: .black, innerCornerRadius: 15, innerBorderColor: .black, innerBorderWidth: 2)
//        CardView(cardDesign: CardDesign(layout: standardCardLayout, renderer: .face(drawable: standardCardFace)))
        CardView(cardDesign: CardDesign(layout: standardCardLayout, renderer: .back(drawable: standardCardBack)))
    }
}
