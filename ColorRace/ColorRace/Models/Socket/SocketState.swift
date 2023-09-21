//
//  SocketState.swift
//  ColorRace
//
//  Created by Anup D'Souza on 04/09/23.
//

import Foundation

enum SocketState {
    case disconnected
    case connectingToServer
    case userConnected
    case userJoined
    case opponentJoined
    case userDisconnected
    case opponentDisconnected
    case gameStarted
    case userLost
}
