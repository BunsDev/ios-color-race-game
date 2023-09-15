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
                CardFaceView(cardLayout: cardDesign.layout, cardFace: cardDrawable, degree: .constant(0), opacity: .constant(1))
            case .back(let cardDrawable):
                CardBackView(cardLayout: cardDesign.layout, cardBack: cardDrawable, degree: .constant(0))
            }
        }
        .frame(width: cardDesign.layout.width, height: cardDesign.layout.height)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardDesign: CardDesign(layout: CardStore.standardCardLayout, renderer: .back(drawable: CardStore.standardCardBack)))
    }
}
