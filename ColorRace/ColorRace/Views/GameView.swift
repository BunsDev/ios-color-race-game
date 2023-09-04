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
    @State private var waiting = false
    @State private var gameInfoViewOpacity: Double = 0
    @State private var isMinimised = false
    @State var animateLoadingView = true
    @Namespace private var cardMinifyAnimation
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : GameUx.navigationFont()]
    }
    
    var body: some View {
        VStack {
            switch gameManager.gameMode {
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
                navigationToolbarCloseButton()
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            gameManager.quitGame()
        }
        .onAppear {
            waiting = false
            animateLoadingView = true
            isMinimised = false
            gameInfoViewOpacity = 0
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
    
    @ViewBuilder private func joinGameView(_ text: String) -> some View {
        VStack {
            Button(text) {
                gameManager.joinGame()
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
    
    @ViewBuilder private func multiPlayerView() -> some View {
        VStack {
            switch gameManager.gameState {
            case .disconnected(let text), .failure(let text):
                joinGameView(text)
            case .connectingToServer(let text), .connectingToOpponent(let text):
                connectingView(text)
            case .preparingGame:
                connectingView(GameStrings.opponentFound)
            case .playing:
                gameView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder private func connectingView(_ text: String) -> some View {
        VStack(spacing: 0) {
            VStack {
                gameInfoView()
                    .opacity(gameInfoViewOpacity)
                Spacer()
                if gameManager.gameState != .preparingGame {
                    CardLoadingView(cards: loadingCardViews(), animate: $animateLoadingView)
                } else {
                    if isMinimised == false {
                        VStack {
                            ZStack {
                                CardFaceView(cardLayout: CardStore.mediumCardLayout, cardFace: CardStore.mediumCardFace, degree: $cardFlipAnimator.frontDegree)
                                CardBackView(cardLayout: CardStore.mediumCardLayout, cardBack: CardStore.mediumCardBack, degree: $cardFlipAnimator.backDegree)
                            }
                            .frame(width: CardStore.mediumCardLayout.width, height: CardStore.mediumCardLayout.height)
                            .matchedGeometryEffect(id: "shape", in: cardMinifyAnimation)
                        }
                    }
                }
                Text(text)
                    .padding(.vertical)
                Button(GameStrings.cancel) {
                    gameManager.quitGame()
                }
                .font(GameUx.buttonFont())
                .foregroundColor(.black)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                Spacer()
            }
            .onAppear {
                if gameManager.gameState != .preparingGame {
                    animateLoadingView = true
                }
            }
//            .onChange(of: gameManager.gameState, perform: { newValue in
//                print("current gamestate: \(gameManager.gameState), received gamestate: \(newValue)")
//                if gameManager.gameState == .preparingGame {
//                    animateLoadingView = false
//                    withAnimation(Animation.linear(duration: 0.5)) {
//                        gameInfoViewOpacity = 1
//                    }
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        cardFlipAnimator.flipCard()
//                    }
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                        withAnimation(.easeInOut) {
//                            isMinimised.toggle()
//                        }
//                    }
//                } else {
//                    animateLoadingView = true
//                    gameInfoViewOpacity = 0
//                }
//            })
            .onReceive(gameManager.$gameState) { state in
                print("current gamestate: \(gameManager.gameState), received gamestate: \(state)")

                if state == .preparingGame {
                    animateLoadingView = true
                    withAnimation(Animation.linear(duration: 0.5)) {
                        gameInfoViewOpacity = 1
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        cardFlipAnimator.flipCard()
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeInOut) {
//                            isMinimised.toggle()
                            isMinimised = true
                        }
                    }
                } else {
                    animateLoadingView = true
                    isMinimised = false
                    cardFlipAnimator.setDefaults()
                    gameInfoViewOpacity = 0
                }
            }
        }
    }
    
    @ViewBuilder private func gameView() -> some View {
        VStack {
            GeometryReader { geometry in
                gameInfoView()
                VStack {
                    BoardViewRepresentable(isMatching: .constant(true), boardColors: $gameManager.boardColors)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .border(.red, width: 1)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .clipped()
    }
    
    @ViewBuilder private func gameInfoView() -> some View {
        HStack {
            if isMinimised {
                VStack {
                    Text(GameStrings.player1)
                        .frame(height: 25)
                    ColorGridView(cardType: .small, colors: gameManager.boardColors)
                        .frame(width: 60, height: 60)
                        .matchedGeometryEffect(id: "shape", in: cardMinifyAnimation)
                }
                .padding(.horizontal)
            } else {
                VStack {
                    Text(GameStrings.player1)
                        .frame(height: 25)
                    ColorGridView(cardType: .small, colors: gameManager.boardColors)
                        .frame(width: 60, height: 60)
                }
                .padding(.horizontal)
            }
            Spacer()
            Text(GameStrings.go)
                .frame(minWidth: 150)
            Spacer()
            VStack {
                Text(GameStrings.player2)
                    .frame(height: 25)
                ColorGridView(cardType: .small, colors: CardStore.defaultBoardColors)
                    .frame(width: 60, height: 60)
            }
            .padding(.horizontal)
        }
        .border(.green, width: 1)
        .frame(height: 100)
    }
    
    @ViewBuilder private func singlePlayerView() -> some View {
        Text(GameStrings.comingSoon)
            .font(GameUx.buttonFont())
    }
}

extension GameView {
    func loadingCardViews() -> [AnyView] {
        [
            AnyView(CardStore.mediumCardBackView),
            AnyView(CardStore.mediumCardBackView),
            AnyView(CardStore.mediumCardBackView)
        ]
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
