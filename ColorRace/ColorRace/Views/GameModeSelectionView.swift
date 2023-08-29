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
                    .font(.custom("Handlee", size: GameFontConfig.titleFontSize))
                    .padding()
                HStack(spacing: 20) {
                    NavigationLink(destination: SinglePlayerView()) {
                        Text(Strings.singlePlayer)
                            .font(.custom("Handlee", size: GameFontConfig.buttonFontSize))
                            .foregroundColor(.black)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    NavigationLink(destination: MultiPlayerView()) {
                        Text(Strings.multiPlayer)
                            .font(.custom("Handlee", size: GameFontConfig.buttonFontSize))
                            .foregroundColor(.black)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
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
