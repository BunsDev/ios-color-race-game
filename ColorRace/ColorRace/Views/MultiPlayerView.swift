//
//  MultiPlayerView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 21/08/23.
//

import SwiftUI

struct MultiPlayerView: View {
    @Environment(\.presentationMode) var presentation
    @StateObject private var gameViewModel = GameViewModel()
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Handlee", size: GameFontConfig.subtitleFontSize)!]
    }

    var body: some View {
        VStack {
//            switch socketManager.gameState {
//            case .disconnected:
//                Spacer()
//                Button("Join a game") {
//                    socketManager.closeConnection()
//                    socketManager.establishConnection()
//                }
//                .font(.custom("Handlee", size: GameFontConfig.buttonFontSize))
//                .foregroundColor(.black)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.black, lineWidth: 1)
//                )
//                Spacer()
//            case .connectingToServer:
//                Spacer()
//                CardLoadingView(card: CardStore.standard)
//                Spacer()
//                Text("Connecting to server...")
//                Button("Cancel connection") {
//                    socketManager.closeConnection()
//                }
//                .font(.custom("Handlee", size: GameFontConfig.buttonFontSize))
//                .foregroundColor(.black)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.black, lineWidth: 1)
//                )
//                Spacer()
//            case .connectingToOpponent:
//                Spacer()
//                CardLoadingView(card: CardStore.standard)
//                Spacer()
//                Text("Finding an opponent...")
//                Button("Cancel connection") {
//                    socketManager.closeConnection()
//                }
//                .font(.custom("Handlee", size: GameFontConfig.buttonFontSize))
//                .foregroundColor(.black)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.black, lineWidth: 1)
//                )
//                Spacer()
//            case .failure:
//                Spacer()
//                Text("An error occurred while connecting..")
//                Button("Join a game") {
//                    socketManager.closeConnection()
//                    socketManager.establishConnection()
//                }
//                .font(.custom("Handlee", size: GameFontConfig.buttonFontSize))
//                .foregroundColor(.black)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.black, lineWidth: 1)
//                )
//                Spacer()
//            case .playing:
//                VStack {
//                    HStack(alignment: .center) {
//                        CardView(card: CardStore.small)
//                        Spacer()
//                        Button("x") {
//                            print("Quit Game?")
//                        }
//                        .font(.custom("Handlee", size: GameFontConfig.buttonFontSize))
//                        .foregroundColor(.black)
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//                    .border(.red, width: 1)
//                    VStack {
//                        CardView(card: CardStore.standard)
//                            .border(.green, width: 1)
//                    }
//                }.border(.blue, width: 1)
//            }
        }
        .border(.cyan, width: 1)
        .navigationBarTitle(GameStrings.title).font(.custom("Handlee", size: GameFontConfig.subtitleFontSize))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(" X ") {
                    print("quit game")
                    self.presentation.wrappedValue.dismiss()
                }
                .font(.custom("Handlee", size: GameFontConfig.buttonFontSize))
                .foregroundColor(.black)
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            //socketManager.closeConnection()
            print("disappearing....")
        }
    }
}

struct MultiPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MultiPlayerView()
    }
}
