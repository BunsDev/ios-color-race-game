//
//  GameViewModel.swift
//  ColorRace
//
//  Created by Anup D'Souza on 29/08/23.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @ObservedObject private var gameManager: GameManager = GameManager()
    
    func joinGame() {
        gameManager.joinGame()
    }
    
    func quitGame() {
        gameManager.quitGame()
    }
    
    func gameMode() -> GameMode {
        gameManager.gameMode
    }

    func gameState() -> GameState {
        gameManager.gameState
    }
    
    
}
