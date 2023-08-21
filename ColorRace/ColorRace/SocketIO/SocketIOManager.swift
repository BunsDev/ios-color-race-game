//
//  SocketIOManager.swift
//  ColorRace
//
//  Created by Anup D'Souza on 17/08/23.
//

import Foundation
import SocketIO

class SocketIOManager: ObservableObject {
    static let shared = SocketIOManager()
    private var manager: SocketManager
    private var socket: SocketIOClient!
    private let socketURL = URL(string: "http://localhost:3000")!
    @Published var gameState = GameState.disconnected
    
    private init() {
        manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress])
        socket = manager.defaultSocket
        
        socket.on("namespaceAssigned") { data, _ in
            if let dict = data[0] as? [String: String], let namespace = dict["name"] {
                print("client: assigned namespace \(namespace)")
            }
        }
        
        socket.on("userConnected") { [weak self] data, _ in
            print("client: userConnected")
            self?.gameState = .waitingForOpponent
        }
    }
    
    func establishConnection() {
        gameState = .connectingToServer
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
        self.gameState = .disconnected
    }
    
    func joinGame(username: String) {
        socket.emit("joinGame", username)
    }
    
    func tapButton() {
        socket.emit("tapButton")
    }
    
    func winGame() {
        socket.emit("winGame")
    }
    
    func listenForEvents() {
        socket.on("gameEvent") { data, _ in
            if let event = data[0] as? String {
                print("client: Received event: \(event)")
            }
        }
    }
}
