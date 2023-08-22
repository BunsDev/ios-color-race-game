//
//  CardLoadingView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 19/08/23.
//

import SwiftUI

/// An animating card loading view that displays a stack of cards that fan out
struct CardLoadingView: View {
    @State private var isSpreadOut = false
    @State var card: Card
    @State var cards = [Card]()
    
    init(card: Card) {
        self.card = card
    }

    var body: some View {
        ZStack {
            ForEach(0..<cards.count, id: \.self) { index in
                CardView(card: cards[index])
                    .offset(x: isSpreadOut ? CGFloat(index - 2) * 10 : 0)
                    .rotationEffect(.degrees(isSpreadOut ? Double(index - 2) * 10 : 0), anchor: .bottom)
            }
        }
        .onAppear() {
            cards = [
                CardStore.medium,
                CardStore.medium,
                CardStore.medium,
                CardStore.medium,
                CardStore.medium
            ]
            animateForever()
        }
    }
    
    func startAnimation() {
        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: true)) {
            isSpreadOut.toggle()
        }
    }
    
    private func animateForever() {
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            animateWithDuration(1.0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                animateWithDuration(1.0)
            }
        }
    }
    
    private func animateWithDuration(_ duration: Double) {
        withAnimation(Animation.easeInOut(duration: duration)) {
            self.isSpreadOut.toggle()
        }
    }
}

struct CardContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CardLoadingView(card: CardStore.medium)
    }
}
