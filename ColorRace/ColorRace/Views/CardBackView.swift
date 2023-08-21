//
//  CardBackView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 21/08/23.
//

import SwiftUI

struct CardBackView: View {
    @State var card: Card
    let cornerRadius: CGFloat = 15.0
    let borderWidth: CGFloat = 2.0
    let outerBorderColor: Color = .black
    let innerBorderColor: Color = .white
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(outerBorderColor, lineWidth: borderWidth)
                    .background(RoundedRectangle(cornerRadius: cornerRadius).fill(card.backColor))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(innerBorderColor, lineWidth: borderWidth)
                            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.clear))
                            .overlay(
                                Text(Strings.title)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: GameFontConfig.subtitleFontSize, weight: .bold, design: .rounded))
                            )
                            .padding()
                        
                    )
                
            }
        }
    }
    
    private func roundedRectangle(_ cornerRadius: CGFloat,
                                  borderColor: Color,
                                  borderWidth: CGFloat,
                                  fillColor: Color) -> some View {
        return AnyView {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(borderColor, lineWidth: borderWidth)
                .background(RoundedRectangle(cornerRadius: cornerRadius).fill(fillColor))
        }
    }
}

struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        CardBackView(card: CardStore.standard)
    }
}
