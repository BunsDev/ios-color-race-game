//
//  GameManager.swift
//  ColorRace
//
//  Created by Anup D'Souza on 29/08/23.
//

import Foundation
import SwiftUI

final class GameManager: ObservableObject {
    @Published private(set) var gameState: GameState = .disconnected(joinText: GameStrings.joinGame)
    @ObservedObject private var socketManager = SocketIOManager.shared
    @State private(set) var gameMode: GameMode = .multiPlayer

    func joinGame() {
        socketManager.closeConnection()
        socketManager.establishConnection()
    }
    
    func quitGame() {
        socketManager.closeConnection()
    }
}
