//
//  GameView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 29/08/23.
//

import Foundation
import SwiftUI

struct GameView: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject private var gameViewModel = GameViewModel()
    @State private var waiting = true
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : GameUx.navigationFont()]
    }

    var body: some View {
        VStack {
            switch gameViewModel.gameMode() {
            case .multiPlayer:
                multiPlayerView()
                
            case .singlePlayer:
                singlePlayerView()
            }
            
        }
        .border(.cyan, width: 1)
        .navigationBarTitle(GameStrings.title)
        .font(GameUx.subtitleFont())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(GameStrings.close) {
                    self.presentation.wrappedValue.dismiss()
                }
                .font(GameUx.buttonFont())
                .foregroundColor(.black)
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
        }
        .onAppear{
        }
    }
    
    private func multiPlayerView() -> some View {
        return AnyView(
            VStack{
                switch gameViewModel.gameState() {
                case .disconnected(let text), .failure(let text):
                    joinGameView(text)
                case .connectingToServer(let text), .connectingToOpponent(let text):
                    connectingView(text)
                case .playing:
                    VStack{}
                }
            }
        )
    }

    private func joinGameView(_ text: String) -> some View {
        return AnyView(
            VStack {
                Button(text) {
                    gameViewModel.joinGame()
                }
                .font(GameUx.buttonFont())
                .foregroundColor(.black)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
        )
    }

    private func connectingView(_ text: String) -> some View {
        return AnyView(
            VStack(spacing: 40) {
                if waiting {
                    CardLoadingView(cards: gameViewModel.loadingCardViews())
                } else {
                    CardStore.mediumCardBackView
                }
                Text(text)
                    .font(GameUx.subtitleFont())
                Button(GameStrings.cancel) {
                    gameViewModel.quitGame()
                }
                .font(GameUx.buttonFont())
                .foregroundColor(.black)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
        )
    }
    
    private func singlePlayerView() -> some View {
        return AnyView(
            Text(GameStrings.comingSoon)
                .font(GameUx.buttonFont())
        )
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
