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
            Text("An error occurred while connecting..")
            Text("An error occurred while connecting..")
            Text("An error occurred while connecting..")
            Text("An error occurred while connecting..")
            Text("An error occurred while connecting..")
            Text("An error occurred while connecting..")
            Text("An error occurred while connecting..")
            Text("An error occurred while connecting..")
            Text("An error occurred while connecting..")
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
            case .inGame:
                VStack {
                    HStack(alignment: .center) {
                        CardView(card: CardStore.small)
                        Spacer()
                        Button("x") {
                            print("Quit Game?")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .border(.red, width: 1)
//                    Spacer()
                    VStack {
                        CardView(card: CardStore.standard)
                            .border(.green, width: 1)
                    }
                }.border(.blue, width: 1)
            }
        }.border(.cyan, width: 1)
    }
}

struct MultiPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MultiPlayerView()
    }
}
