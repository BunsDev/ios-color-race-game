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
    @State private var userWon: Bool = false
    @Namespace private var miniCardAnimation
    private let hudViewHeight = 100.0
    
    // background 1    
//    [
//        Color(uiColor: UIColor(red: 22/255, green: 15/255, blue: 62/255, alpha: 1.0)),
//        Color(uiColor: UIColor(red: 48/255, green: 18/255, blue: 80/255, alpha: 1.0)),
//        Color(uiColor: UIColor(red: 23/255, green: 16/255, blue: 64/255, alpha: 1.0)),
//        Color(uiColor: UIColor(red: 17/255, green: 9/255, blue: 52/255, alpha: 1.0))
//    ]
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : GameUx.navigationFont(), .foregroundColor: UIColor.white]
    }
    
    var body: some View {
        ZStack {
            gameView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors:                                   [
                Color(uiColor: UIColor(red: 48/255, green: 18/255, blue: 80/255, alpha: 1.0)),
                Color(uiColor: UIColor(red: 23/255, green: 16/255, blue: 64/255, alpha: 1.0)),
                Color(uiColor: UIColor(red: 42/255, green: 16/255, blue: 72/255, alpha: 1.0))
            ]), startPoint: .top, endPoint: .bottom)
            )
        .border(.black, width: 1.0)
        .font(GameUx.subtitleFont())
            .navigationBarTitle(GameStrings.title)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                navigationToolbarCloseButton()
            }
        }
        .backgroundBlur(radius: 25, opaque: false)
        .onDisappear {
            gameManager.quitGame()
        }
    }
    
    @ViewBuilder private func navigationToolbarCloseButton() -> some View {
        Button(GameStrings.close) {
            self.presentation.wrappedValue.dismiss()
        }
        .font(GameUx.buttonFont())
        .foregroundColor(.white)
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
        case .userWon:
            userWonView()
        case .userLost:
            userLostView()
            // TODO: Get board view to react to loss, show animation, then update state to userLost
            // TODO: Get board view to react to win, show animation, then update state to userWon
        }
    }
    
    @ViewBuilder private func joinGameView(_ text: String) -> some View {
        gameButtonView(text: text) {
            gameManager.joinGame()
        }
    }
    
    @ViewBuilder private func connectingView(_ text: String) -> some View {
        VStack {
            CardLoadingView(cards: CardStore.loadingCards())
            connectingStatusView(text, buttonText: GameStrings.cancel) {
                gameManager.quitGame()
            }
        }.onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now()) { withAnimation(.linear) { showMiniCard = true } }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { gameManager.preparedGame() }
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
                    .matchedGeometryEffect(id: "minimise", in: miniCardAnimation)
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
            .multilineTextAlignment(.center)
        gameButtonView(text: buttonText, action: action)
    }

    @ViewBuilder private func userWonView() -> some View {
        VStack {
            Image(systemName: "trophy.circle.fill")
                .font(GameUx.fontWithSize(120))
                .padding(.vertical)
            Text(GameStrings.userWon)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Text(GameStrings.nextRound + "\(gameManager.secondsToNextRound)")
                .padding(.vertical)
                .multilineTextAlignment(.center)
        }
    }

    @ViewBuilder private func userLostView() -> some View {
        VStack {
            Image(systemName: "medal.fill")
                .font(GameUx.fontWithSize(80))
                .padding(.vertical)
            Text(GameStrings.userLost)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Text(GameStrings.nextRound + "\(gameManager.secondsToNextRound)")
                .padding(.vertical)
                .multilineTextAlignment(.center)
        }
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
                userWon = false
            }
        }
        .clipped()
    }
    
    @ViewBuilder private func boardRepresentableView(geometry: GeometryProxy) -> some View {
        VStack {
            BoardViewRepresentable(userWon: $userWon, boardColors: $gameManager.boardColors)
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        .offset(y: showGameBoard ? 0 : geometry.size.height)
        .transition(.slide)
        .animation(.spring(dampingFraction: 0.6), value: showGameBoard)
        .clipped()
        .onChange(of: userWon) { newValue in
            print("boardRepresentableView \(newValue)")
            gameManager.userWonGame()
        }
    }
}

// MARK: - HUD's
extension GameView {

    @ViewBuilder private func animatingHUDView() -> some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Text(GameStrings.player1)
                        .frame(height: 25)
                    if showMiniCard {
                        ColorGridView(cardType: .small, colors: gameManager.boardColors, displayDefault: false)
                            .frame(width: 60, height: 60)
                            .matchedGeometryEffect(id: "minimise", in: miniCardAnimation)
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
                .matchedGeometryEffect(id: "minimise", in: miniCardAnimation)
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
