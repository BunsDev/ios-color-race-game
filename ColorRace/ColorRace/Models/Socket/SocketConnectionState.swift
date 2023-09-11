//
//  SocketConnectionState.swift
//  ColorRace
//
//  Created by Anup D'Souza on 04/09/23.
//

import Foundation

internal enum SocketConnectionState {
    case disconnected
    case userConnected
    case userJoined
    case opponentJoined
    case userDisconnected
    case opponentDisconnected
    case gameStarted
    case connectingToServer
    case userLost
}
