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
    @State private var hudOpacity: Double = 0
    @State private var showGameBoard = false
    @State private var showMiniCard = false
    @State private var userWon: Bool = false
    @State private var faceCardOpacity = 1.0
    @Namespace private var miniCardAnimation
    private let hudViewHeight = 75.0
    private let hudVerticalPadding = 20.0
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : GameUx.navigationFont(), .foregroundColor: GameUx.brandUIColor()]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            gameView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            BackgroundView()
        )
        .font(GameUx.subtitleFont())
        .navigationBarTitle(GameStrings.title)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                navigationCloseButton()
            }
        }
        .foregroundColor(GameUx.brandColor())
        .onDisappear {
            gameManager.quitGame()
        }
    }
    
    @ViewBuilder private func navigationCloseButton() -> some View {
        Button {
            self.presentation.wrappedValue.dismiss()
        } label: {
            Image(systemName: "arrowshape.turn.up.backward.fill")
        }
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
        case .userWon:
            gameResultView(true)
        case .userLost:
            gameResultView(false)
        }
    }
    
    @ViewBuilder private func joinGameView(_ text: String) -> some View {
        gameButtonView(text: text) {
            gameManager.joinGame()
        }
    }
    
    @ViewBuilder private func connectingView(_ text: String) -> some View {
        VStack(spacing: 0) {
            CardLoadingView(cards: CardStore.loadingCards())
            connectingStatusView(text, buttonText: GameStrings.cancel) {
                gameManager.quitGame()
            }
        }
        .border(.red)
    }

    @ViewBuilder private func connectedView(_ text: String) -> some View {
        animatingHUDView(showDefault: true)
            .padding(.horizontal, 20)
            .opacity(hudOpacity)
        GeometryReader { proxy in
            VStack(spacing: 0) {
                flippingCardView()
                connectingStatusView(text, buttonText: GameStrings.cancel) {
                    gameManager.quitGame()
                }
                .opacity(faceCardOpacity)
            }.position(x: proxy.frame(in: .local).midX,
                       y: proxy.frame(in: .local).midY - hudViewHeight/2 - hudVerticalPadding)
                .border(.green)
        }
        .onAppear {
            cardFlipAnimator.setDefaults()
            withAnimation(.easeInOut(duration: 0.25)) { hudOpacity = 1 }
            withAnimation(.easeInOut.delay(0.25)) { cardFlipAnimator.flipCard() }
            withAnimation(.easeInOut.delay(0.75)) { faceCardOpacity = 0 }
            withAnimation(.easeInOut.delay(1.0)) { showMiniCard = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { gameManager.preparedGame() }
        }
        .onDisappear {
            hudOpacity = 0
            faceCardOpacity = 1
            showMiniCard = false
            cardFlipAnimator.setDefaults()
        }
    }
    
    @ViewBuilder private func flippingCardView() -> some View {
        ZStack {
            CardFaceView(cardLayout: CardStore.mediumCardLayout,
                         cardFace: CardStore.mediumCardFaceWithColors(gameManager.boardColors),
                         degree: $cardFlipAnimator.frontDegree,
                         opacity: $faceCardOpacity)
                .matchedGeometryEffect(id: showMiniCard ? "minimise" : "", in: miniCardAnimation, properties: .position, isSource: false)
            CardBackView(cardLayout: CardStore.mediumCardLayout,
                         cardBack: CardStore.mediumCardBack,
                         degree: $cardFlipAnimator.backDegree)
        }
        .border(.black)
        .frame(width: CardStore.mediumCardLayout.width, height: CardStore.mediumCardLayout.height)
    }

    @ViewBuilder private func connectingStatusView(_ statusText: String, buttonText: String, action: @escaping () -> Void) -> some View {
        Text(statusText)
            .padding(.vertical)
            .multilineTextAlignment(.center)
        gameButtonView(text: buttonText, action: action)
    }
    
    @ViewBuilder private func gameResultView(_ result: Bool) -> some View {
        animatingHUDView(showDefault: false)
            .padding(.horizontal, 20)
        GeometryReader { proxy in
            VStack {
                LottieViewRepresentable(filename: "animation_losing", loopMode: .playOnce)
                    .rotationEffect(.degrees(result ? 180 : 0))
                    .frame(width: 150, height: 150)
                Text(result ? GameStrings.userWon : GameStrings.userLost)
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
                Text(GameStrings.nextRound + "\(gameManager.secondsToNextRound)")
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
            }.position(x: proxy.frame(in: .local).midX,
                       y: proxy.frame(in: .local).midY)
                .border(.green)
        }
    }
    
    @ViewBuilder private func gameButtonView(text: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(GameUx.buttonFont())
                .padding(.horizontal, 60)
                .foregroundColor(.white)
        }
        .tint(GameUx.brandColor())
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
    }
}

// MARK: - Board
extension GameView {
    
    @ViewBuilder private func boardView() -> some View {
        animatingHUDView(showDefault: false)
            .padding(.horizontal, 20)
        boardRepresentableView()
                .border(.red)
    }
    
    @ViewBuilder private func boardRepresentableView() -> some View {
        BoardViewRepresentable(userWon: $userWon, boardColors: $gameManager.boardColors)
            .offset(y: showGameBoard ? 0 : UIScreen.main.bounds.size.height)
            .transition(.slide)
            .animation(.spring(dampingFraction: 0.6), value: showGameBoard)
            .clipped()
            .onChange(of: userWon) { newValue in
                print("boardRepresentableView \(newValue)")
                gameManager.userWonGame()
            }
            .onAppear {
                showGameBoard = true
            }
            .onDisappear {
                showGameBoard = false
                userWon = false
            }
    }
}

// MARK: - HUD's
extension GameView {
    
    @ViewBuilder private func animatingHUDView(showDefault: Bool) -> some View {
        HStack {
            player1HUDView(showDefault: showDefault)
            Spacer()
            player2HUDView()
        }
        .frame(height: hudViewHeight)
        .padding(.vertical, hudVerticalPadding)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
    }
    
    @ViewBuilder private func player1HUDView(showDefault: Bool) -> some View {
        VStack {
            Text(GameStrings.player1)
                .frame(height: 25)
            ColorGridView(colors: gameManager.boardColors, displayDefault: showDefault)
                .frame(width: 50, height: 50)
                .matchedGeometryEffect(id: "minimise", in: miniCardAnimation, properties: .frame, isSource: true)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private func player2HUDView() -> some View {
        VStack {
            Text(GameStrings.player2)
                .frame(height: 25)
            ColorGridView(colors: CardStore.defaultBoardColors, displayDefault: true)
                .frame(width: 50, height: 50)
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
