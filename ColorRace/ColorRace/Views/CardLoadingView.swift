//
//  CardLoadingView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 19/08/23.
//

import SwiftUI

// TODO: Calculate correct rotation degrees for varying number of cards
extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}

struct CardLoadingView: View {
    @State var cards: [AnyView]
    @State var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<cards.count, id: \.self) { index in
                cards[index]
                    .offset(x: animate ? CGFloat(index - midIndex()) * 10 : 0)
                    .rotationEffect(.degrees(animate ? Double(index - midIndex()) * 10 : 0), anchor: .bottom)
                    .animation(Animation.easeInOut(duration: 1).delay(0.25).repeat(while: animate), value: animate)
            }
        }
        .onAppear() {
            startAnimation()
        }
    }
    
    func startAnimation() {
        withAnimation(Animation.linear(duration: 0.75).delay(0.25).repeatForever(autoreverses: true)) {
            animate.toggle()
        }
    }
    
    private func midIndex() -> Int {
        return cards.count / 2
    }
}

struct CardContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let standardCardLayout = CardLayout(width: 200, height: 330, color: .white, cornerRadius: 15, borderWidth: 2, borderColor: .black)
        let standardCardFace = CardFace(letter: "10", suit: "♣️", fontSize: 20, colors: CardStore.defaultBoardColors)
        let standardCardBack = CardBack(text: "CR", font: GameUx.titleFont(), textColor: .black, innerCornerRadius: 15, innerBorderColor: .black, innerBorderWidth: 2)
        let cardFaceView = CardView(cardDesign: CardDesign(layout: standardCardLayout, renderer: .face(drawable: standardCardFace)))
        let cardBackView = CardView(cardDesign: CardDesign(layout: standardCardLayout, renderer: .back(drawable: standardCardBack)))
        let cards = [
            AnyView(cardFaceView),
            AnyView(cardBackView),
            AnyView(cardBackView),
            AnyView(cardBackView),
            AnyView(cardBackView)
        ]
        CardLoadingView(cards: cards)
    }
}
