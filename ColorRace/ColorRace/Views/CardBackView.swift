//
//  CardBackView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 21/08/23.
//

import SwiftUI

struct CardBackView: View {
    @State var cardLayout: CardLayout
    @State var cardBack: CardBackDrawable
    @Binding var degree: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardLayout.cornerRadius)
                .strokeBorder(cardLayout.borderColor, lineWidth: cardLayout.borderWidth)
                .background(
                    RoundedRectangle(cornerRadius: cardLayout.cornerRadius).fill(cardLayout.color)
                )
                .frame(width: cardLayout.width, height: cardLayout.height)
                .overlay(
                    RoundedRectangle(cornerRadius: cardLayout.cornerRadius)
                        .strokeBorder(cardBack.innerBorderColor, lineWidth: cardLayout.borderWidth)
                        .background(RoundedRectangle(cornerRadius: cardLayout.cornerRadius).fill(Color.clear))
                        .padding(10)
                )
                .overlay(
                    DiamondPatternView(rows: 21, cols: 7, color: cardBack.innerBorderColor)
                        .padding(15)
                )
            
        }
        .frame(width: cardLayout.width, height: cardLayout.height)
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        CardStore.mediumCardBackView
    }
}
