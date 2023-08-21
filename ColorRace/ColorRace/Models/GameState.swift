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
    case failure
}

internal struct GameFontConfig {
    static let titleFontSize: CGFloat = 50
    static let subtitleFontSize: CGFloat = 20
    static let buttonFontSize: CGFloat = 20
}
