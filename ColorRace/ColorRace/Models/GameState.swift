//
//  GameState.swift
//  ColorRace
//
//  Created by Anup D'Souza on 21/08/23.
//

import Foundation

internal enum GameState {
    case disconnected(joinText: String)
    case connectingToServer(connectionText: String)
    case connectingToOpponent(connectionText: String)
    case failure(errorText: String)
    case playing
}
