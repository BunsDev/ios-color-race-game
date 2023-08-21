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
                Text(Strings.title)
                    .font(.system(size: GameFontConfig.titleFontSize, weight: .bold, design: .rounded))
                    .padding()
                HStack(spacing: 20) {
                    NavigationLink(destination: SinglePlayerView()) {
                        Text(Strings.singlePlayer)
                            .font(.system(size: GameFontConfig.buttonFontSize, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .shadow(color: .black, radius: 1)
                    NavigationLink(destination: MultiPlayerView()) {
                        Text(Strings.multiPlayer)
                            .font(.system(size: GameFontConfig.buttonFontSize, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .shadow(color: .black, radius: 1)
                }
                Spacer()
            }
        }
    }
}

struct GameModeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GameModeSelectionView()
    }
}
