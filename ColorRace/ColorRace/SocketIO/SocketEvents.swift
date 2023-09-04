//
//  SocketEvents.swift
//  ColorRace
//
//  Created by Anup D'Souza on 29/08/23.
//

import Foundation

internal struct SocketEvents {
    static let userConnected = "userConnected"
    static let userJoined = "userJoined"
    static let gameStarted = "gameStarted"
    static let userDisconnected = "userDisconnected"
}

internal enum SocketConnectionState {
    case disconnected
    case userConnected
    case userJoined
    case opponentJoined
    case userDisconnected
    case opponentDisconnected
    case gameStarted
    case connectingToServer
}
