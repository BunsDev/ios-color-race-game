//
//  GameState.swift
//  ColorRace
//
//  Created by Anup D'Souza on 21/08/23.
//

import Foundation

internal enum GameState {
    case disconnected
    case connectingToServer
    case waitingForOpponent
    case playing
    case failure
}

internal struct GameFontConfig {
    static let titleFontSize: CGFloat = 50
    static let subtitleFontSize: CGFloat = 20
    static let buttonFontSize: CGFloat = 20
}

internal struct SocketEvents {
    static let userConnected = "userConnected"
    static let userJoined = "userJoined"
    static let gameStarted = "gameStarted"
    static let userDisconnected = "userDisconnected"
}
