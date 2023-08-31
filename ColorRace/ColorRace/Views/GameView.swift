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
    @State private var waiting = false
    
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
                Button(GameStrings.close) {
                    self.presentation.wrappedValue.dismiss()
                }
                .font(GameUx.buttonFont())
                .foregroundColor(.black)
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            gameManager.quitGame()
        }
        .onAppear{
            waiting = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                self.waiting = false
//            }
        }
    }
    
    private func multiPlayerView() -> some View {
        return AnyView(
            VStack{
                switch gameManager.gameState {
                case .disconnected(let text), .failure(let text):
                    joinGameView(text)
                case .connectingToServer(let text), .connectingToOpponent(let text):
                    connectingView(text)
                case .preparingGame:
                    connectingView("Opponent found !")
                case .playing:
                    gameView()
                }
            }
        )
    }

    private func joinGameView(_ text: String) -> some View {
        return AnyView(
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
        )
    }
    
    // TODO: Create Card animator instance for flip animation
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    @State var flipAnimationCompleted = false
    
    let durationAndDelay : CGFloat = 0.3
    @State var infoBarOpacity: Double = 0
    @State var isMinimised = false
    
    func flipCard () {
        // TODO: limit flip animation to times = 1 only and notify parent via flipAnimationCompleted or something else using dispatch queue with the accumulated sum of durationAndDelay required for animation to complete
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }

    @Namespace private var animation
    private func connectingView(_ text: String) -> some View {
        return AnyView(
            VStack(spacing: 40) {
                if waiting {
                    CardLoadingView(cards: loadingCardViews())
                } else {
                    // info view
                    VStack {
                        HStack {
                            if isMinimised {
                                VStack {
                                    Text("You")
                                        .frame(height: 25)
                                    ColorGridView(cardType: .small, colors: gameManager.boardColors)
                                        .frame(width: 60, height: 60)
                                        .matchedGeometryEffect(id: "shape", in: animation)
                                }
                                .padding(.horizontal)
                            }
                            Spacer()
                            Text("Go !")
                                .frame(minWidth: 150)
                            Spacer()
                            VStack {
                                Text("Player 2")
                                    .frame(height: 25)
                                Color.mint
                                    .frame(width: 60, height: 60)
                            }
                            .padding(.horizontal)
                        }
                        .border(.green, width: 1)
                    }
                    .opacity(infoBarOpacity)
                    .frame(height: 100)
//                    .frame(width: geometry.size.width, height: 100)
                    if isMinimised == false {
                        VStack {
                            // TODO: swap out to a preparing view
                            ZStack {
                                CardFaceView(cardLayout: CardStore.mediumCardLayout, cardFace: CardStore.mediumCardFace, degree: $frontDegree)
                                CardBackView(cardLayout: CardStore.mediumCardLayout, cardBack: CardStore.mediumCardBack, degree: $backDegree)
                            }
                            .frame(width: CardStore.mediumCardLayout.width, height: CardStore.mediumCardLayout.height)
                            .matchedGeometryEffect(id: "shape", in: animation)
                        }
                    }
                }
                Text(text)
                    .font(GameUx.subtitleFont())
                Button(GameStrings.cancel) {
                    if gameManager.gameState == .preparingGame {
//                        flipCard()
                        withAnimation(.spring()) {
                            isMinimised.toggle()
                        }
                    } else {
                        gameManager.quitGame()
                    }
                }
                .font(GameUx.buttonFont())
                .foregroundColor(.black)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                .onAppear {
                    if gameManager.gameState == .preparingGame {
                        waiting = false
                        DispatchQueue.main.async {
                            self.flipCard()
                        }
                        withAnimation(Animation.linear(duration: 0.5)) {
                            infoBarOpacity = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            
                            withAnimation(.spring()) {
                                isMinimised.toggle()
                            }
                        }
                    } else {
                        waiting = true
                    }
                }
            }
        )
    }
    
    private func gameView() -> some View {
        return AnyView(
            VStack {
                GeometryReader { geometry in
                    VStack {
                        HStack {
                            VStack {
                                Text("You")
                                    .frame(height: 25)
                                ColorGridView(cardType: .small, colors: gameManager.boardColors)
                                    .frame(width: 60, height: 60)
                            }
                            .padding(.horizontal)
                            Spacer()
                            Text("Go !")
                                .frame(minWidth: 150)
                            Spacer()
                            VStack {
                                Text("Player 2")
                                    .frame(height: 25)
                                Color.mint
                                    .frame(width: 60, height: 60)
                            }
                            .padding(.horizontal)
                        }
                        .border(.green, width: 1)
                    }
                    .frame(width: geometry.size.width, height: 100)
                    VStack {
                        BoardViewRepresentable(isMatching: .constant(true), boardColors: $gameManager.boardColors)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .border(.red, width: 1)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .clipped()
        )
    }
    
    private func singlePlayerView() -> some View {
        return AnyView(
            Text(GameStrings.comingSoon)
                .font(GameUx.buttonFont())
        )
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
