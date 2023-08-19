//
//  CardContainerView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 19/08/23.
//

import SwiftUI

struct CardContainerView: View {
    @State private var isSpreadOut = false
    
    var body: some View {
        ZStack {
            ForEach(0..<5) { index in
                CardView(color: Color.blue)
                    .offset(x: isSpreadOut ? CGFloat(index - 2) * 10 : 0)
                    .rotationEffect(.degrees(isSpreadOut ? Double(index - 2) * 10 : 0), anchor: .bottom)
            }
        }
        .onAppear() {
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
        CardContainerView()
    }
}
