//
//  GameLobbyView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 21/08/23.
//

import SwiftUI

struct GameLobbyView: View {
    @State var socketManager = SocketIOManager.shared
    var body: some View {
        VStack {
            Spacer()
            //CardLoadingView(card: CardStore.standard)
            Spacer()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onAppear {
                    socketManager.establishConnection()
                }
        }
    }
}

struct GameLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        GameLobbyView()
    }
}
