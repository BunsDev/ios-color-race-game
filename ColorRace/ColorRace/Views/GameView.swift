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
    @ObservedObject private var gameManager = GameManager()
    @ObservedObject private var cardFlipAnimator = CardFlipAnimator()
    @State private var animatingHUDViewOpacity: Double = 0
    @State private var showGameBoard = false
    @State private var showMiniCard = false
    @State private var isMatching = false // TODO: Tie to board view
    @Namespace private var miniCardAnimation
    private let hudViewHeight = 100.0
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : GameUx.navigationFont()]
    }
    
    var body: some View {
        ZStack {
            gameView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(.black, width: 1.0)
        .font(GameUx.subtitleFont())
        .navigationBarTitle(GameStrings.title)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                navigationToolbarCloseButton()
            }
        }
        .onDisappear {
            gameManager.quitGame()
        }
    }
    
    @ViewBuilder private func navigationToolbarCloseButton() -> some View {
        Button(GameStrings.close) {
            self.presentation.wrappedValue.dismiss()
        }
        .font(GameUx.buttonFont())
        .foregroundColor(.black)
        .padding(.horizontal)
    }
    
    @ViewBuilder private func gameView() -> some View {
        switch gameManager.gameState {
        case .disconnected(let text), .failure(let text):
            joinGameView(text)
        case .connectingToServer(let text), .connectingToOpponent(let text):
            connectingView(text)
        case .preparingGame:
            connectedView(GameStrings.opponentFound)
        case .playing:
            boardView()
        }
    }
    
    @ViewBuilder private func joinGameView(_ text: String) -> some View {
        gameButtonView(text: text) {
            gameManager.joinGame()
        }
    }

    @ViewBuilder private func animatingHUDView() -> some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Text(GameStrings.player1)
                        .frame(height: 25)
                    if showMiniCard {
                        ColorGridView(cardType: .small, colors: gameManager.boardColors, displayDefault: false)
                            .frame(width: 60, height: 60)
                            .matchedGeometryEffect(id: "shape", in: miniCardAnimation)
                    } else {
                        Text("?")
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                            .border(.black, width: 0.5)
                    }
                }
                .padding(.horizontal)
                Spacer()
                Text(GameStrings.play)
                    .frame(minWidth: 150)
                Spacer()
                player2HUDView()
            }
            .frame(width: geometry.size.width, height: hudViewHeight)
            .border(.red, width: 1)
        }
    }
    
    @ViewBuilder private func connectingView(_ text: String) -> some View {
        VStack {
            CardLoadingView(cards: CardStore.loadingCards())
            connectingStatusView(text, buttonText: GameStrings.cancel) {
                gameManager.quitGame()
            }
        }
    }
    
    @ViewBuilder private func connectedView(_ text: String) -> some View {
        animatingHUDView()
            .opacity(animatingHUDViewOpacity)
        VStack {
            if showMiniCard == false {
                VStack {
                    ZStack {
                        CardFaceView(cardLayout: CardStore.mediumCardLayout, cardFace: CardStore.mediumCardFaceWithColors(gameManager.boardColors), degree: $cardFlipAnimator.frontDegree)
                        CardBackView(cardLayout: CardStore.mediumCardLayout, cardBack: CardStore.mediumCardBack, degree: $cardFlipAnimator.backDegree)
                    }
                    .frame(width: CardStore.mediumCardLayout.width, height: CardStore.mediumCardLayout.height)
                    .matchedGeometryEffect(id: "shape", in: miniCardAnimation)
                }
            }
            connectingStatusView(text, buttonText: GameStrings.cancel) {
                gameManager.quitGame()
            }
            .opacity(showMiniCard ? 0 : 1)
        }
        .onAppear {
            cardFlipAnimator.setDefaults()
            withAnimation(.linear(duration: 0.25)) { animatingHUDViewOpacity = 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { cardFlipAnimator.flipCard() } // cardFlipAnimation lasts ~ 0.75s
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { withAnimation(.linear) { showMiniCard = true } }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { gameManager.preparedGame() }
        }
        .onDisappear {
            showMiniCard = false
            animatingHUDViewOpacity = 0
            cardFlipAnimator.setDefaults()
        }
    }
    
    @ViewBuilder private func connectingStatusView(_ statusText: String, buttonText: String, action: @escaping () -> Void) -> some View {
        Text(statusText)
            .padding(.vertical)
        gameButtonView(text: buttonText, action: action)
    }
    
    @ViewBuilder private func gameButtonView(text: String, action: @escaping () -> Void) -> some View {
        Button(text) {
            action()
        }
        .font(GameUx.buttonFont())
        .foregroundColor(.black)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
        )
    }
}

// MARK: - Board
extension GameView {
    
    @ViewBuilder private func boardView() -> some View {
        VStack {
            GeometryReader { geometry in
                gameHUDView()
                boardRepresentableView(geometry: geometry)
            }
            .onAppear {
                showGameBoard = true
            }
            .onDisappear {
                showGameBoard = false
            }
        }
        .clipped()
    }
    
    @ViewBuilder private func boardRepresentableView(geometry: GeometryProxy) -> some View {
        VStack {
            BoardViewRepresentable(isMatching: .constant(true), boardColors: $gameManager.boardColors)
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        .offset(y: showGameBoard ? 0 : geometry.size.height)
        .transition(.slide)
        .animation(.spring(dampingFraction: 0.6), value: showGameBoard)
        .clipped()
    }
}

// MARK: - HUD's
extension GameView {
    
    @ViewBuilder private func gameHUDView() -> some View {
        HStack {
            player1HUDView()
            Spacer()
            Text(GameStrings.play)
                .frame(minWidth: 150)
            Spacer()
            player2HUDView()
        }
        .frame(height: hudViewHeight)
    }
    
    @ViewBuilder private func player1HUDView() -> some View {
        VStack {
            Text(GameStrings.player1)
                .frame(height: 25)
            ColorGridView(cardType: .small, colors: gameManager.boardColors, displayDefault: false)
                .frame(width: 60, height: 60)
                .matchedGeometryEffect(id: "shape", in: miniCardAnimation)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private func player2HUDView() -> some View {
        VStack {
            Text(GameStrings.player2)
                .frame(height: 25)
            ColorGridView(cardType: .small, colors: CardStore.defaultBoardColors, displayDefault: true)
                .frame(width: 60, height: 60)
        }
        .padding(.horizontal)
    }
}

// MARK: - PreviewProvider
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
