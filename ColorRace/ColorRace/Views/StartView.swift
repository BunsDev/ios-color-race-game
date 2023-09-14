//
//  StartView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 20/08/23.
//

import SwiftUI

struct StartView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    Text(GameStrings.title)
                        .font(GameUx.titleFont())
                        .foregroundColor(GameUx.brandColor())
                        .padding()
                    NavigationLink(destination: GameView()) {
                        textView(GameStrings.enter)
                    }
                    .tint(GameUx.brandColor())
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder private func textView(_ title: String) -> some View {
        Text(title)
            .font(GameUx.buttonFont())
            .foregroundColor(.white)
            .padding(.horizontal, 60)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
