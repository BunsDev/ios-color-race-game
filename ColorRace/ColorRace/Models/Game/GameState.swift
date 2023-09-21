//
//  GameState.swift
//  ColorRace
//
//  Created by Anup D'Souza on 21/08/23.
//

import Foundation

enum GameState: Equatable {
    case disconnected(text: String)
    case connectingToServer(text: String)
    case connectingToOpponent(text: String)
    case preparingGame(text: String)
    case playing
    case userWon
    case userLost
    
    var userIsInGame: Bool {
        if case .preparingGame(_) = self {
            return true
        } else if case .playing = self {
            return true
        }
        return false
    }
}
