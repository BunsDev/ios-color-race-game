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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: cardLayout.cornerRadius)
                    .strokeBorder(cardLayout.borderColor, lineWidth: cardLayout.borderWidth)
                    .background(RoundedRectangle(cornerRadius: cardLayout.cornerRadius).fill(cardLayout.color))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        RoundedRectangle(cornerRadius: cardLayout.cornerRadius)
                            .strokeBorder(cardBack.innerBorderColor, lineWidth: cardLayout.borderWidth)
                            .background(RoundedRectangle(cornerRadius: cardLayout.cornerRadius).fill(Color.clear))
                            .overlay(
                                Text(cardBack.text)
                                    .foregroundColor(cardBack.textColor)
                                    .multilineTextAlignment(.center)
                                    .font(cardBack.font)
                            )
                            .padding()
                        
                    )
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        CardStore.standardCardBackView
    }
}
