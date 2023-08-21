//
//  MultiPlayerView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 21/08/23.
//

import SwiftUI

struct MultiPlayerView: View {
    @ObservedObject private var socketManager = SocketIOManager.shared
    
    var body: some View {
        VStack {
            switch socketManager.gameState {
            case .disconnected:
                Spacer()
                Button("Join a game") {
                    socketManager.closeConnection()
                    socketManager.establishConnection()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                Spacer()
            case .connectingToServer:
                Spacer()
                CardLoadingView(card: CardStore.standard)
                Spacer()
                Text("Connecting to server...")
                Button("Cancel connection") {
                    socketManager.closeConnection()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                Spacer()
            case .waitingForOpponent:
                Spacer()
                CardLoadingView(card: CardStore.standard)
                Spacer()
                Text("Finding an opponent...")
                Button("Cancel connection") {
                    socketManager.closeConnection()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                Spacer()
            case .failure:
                Spacer()
                Text("An error occurred while connecting..")
                Button("Join a game") {
                    socketManager.establishConnection()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                Spacer()
            }
        }
    }
}

struct MultiPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MultiPlayerView()
    }
}
