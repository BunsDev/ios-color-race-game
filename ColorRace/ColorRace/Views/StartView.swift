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
            VStack {
                Spacer()
                Text("Color Race")
                    .font(.largeTitle)
                    .padding()
                
                HStack(spacing: 20) {
                    NavigationLink(destination: SinglePlayerView()) {
                        Text("1 Player")
                    }.buttonStyle(.borderedProminent)
                        .tint(.red)
                    NavigationLink(destination: GameLobbyView()) {
                        Text("2 Player")
                    }.buttonStyle(.borderedProminent)
                        .tint(.red)
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}

struct SinglePlayerView: View {
    var body: some View {
        Text("Single Player View")
            .font(.largeTitle)
    }
}

struct MultiPlayerView: View {
    var body: some View {
        Text("Multi Player View")
            .font(.largeTitle)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
