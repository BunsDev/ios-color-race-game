//
//  GameManager.swift
//  ColorRace
//
//  Created by Anup D'Souza on 29/08/23.
//

import Foundation
import SwiftUI

final class GameManager: ObservableObject {
    @ObservedObject private var socketManager = SocketIOManager.shared
    @Published var gameState = GameState.disconnected
    
}
