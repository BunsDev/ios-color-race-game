//
//  BackgroundView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 14/09/23.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            GameUx.background()
                .overlay {
                    VStack(spacing: 0) {
                        ForEach(0..<20) { index in
                            Divider()
                                .overlay(Color.white.opacity(0.5))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .overlay {
                    HStack(spacing: 0) {
                        ForEach(0..<10) { index in
                            Divider()
                                .overlay(Color.white.opacity(0.1))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Image(systemName: CardDetail.suits.randomElement()!)
                        .font(.system(size: 150))
                        .frame(width: 200, height: 200)
                        .offset(x: -50)
                        .rotationEffect(.degrees(-180))
                        .foregroundColor(GameUx.brandLightColor())
                }
                .overlay(alignment: .bottomLeading) {
                    Image(systemName: CardDetail.suits.randomElement()!)
                        .font(.system(size: 300))
                        .frame(width: 300, height: 200)
                        .offset(x: -100)
                        .foregroundColor(GameUx.brandLightColor())
                }
        }
//        .blur(radius: 2)
        .ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
