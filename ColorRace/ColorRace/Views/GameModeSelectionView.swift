//
//  GameModeSelectionView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 20/08/23.
//

import SwiftUI

struct GameModeSelectionView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(GameStrings.title)
                    .font(GameUx.titleFont())
                    .padding()
                HStack(spacing: 20) {
                    NavigationLink(destination: GameView()) {
                        textView(GameStrings.singlePlayer)
                    }
                    NavigationLink(destination: GameView()) {
                        textView(GameStrings.multiPlayer)
                    }
                }
                Spacer()
            }
        }
    }
    
    private func textView(_ title: String) -> some View {
        return AnyView(
            Text(title)
                .font(GameUx.buttonFont())
                .foregroundColor(.black)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
        )
    }
}

struct GameModeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GameModeSelectionView()
    }
}
