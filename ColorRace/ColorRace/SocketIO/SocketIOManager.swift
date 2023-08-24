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
    private var namespace: String?
    
    private init() {
        manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }

    private func addEventListeners() {
        socket.on("namespaceAssigned") {[weak self] data, _ in
            
            print("client => received event: namespaceAssigned")
            
            guard let namespace = data[0] as? String else {

                print("client => failed to read namespace")
                self?.socket.disconnect()
                return
            }

            print("client => received nameapace: \(namespace)")
            self?.namespace = namespace
        }
        
        socket.on("userConnected") { [weak self] data, _ in
            print("client => received event: userConnected")
            self?.gameState = .waitingForOpponent
        }
        
        socket.on("foundOpponent") { [weak self] data, _ in
            print("client => received event: foundOpponent")
            self?.gameState = .inGame
        }
        
        socket.on("userDisconnected") { [weak self] data, _ in
            if let namespaceUserCount = data.first as? Int {
                print("client => connected user count: ", namespaceUserCount)
            }
            print("client => received event: userDisconnected, for namespace: ", String(describing: self?.namespace))
            self?.gameState = .waitingForOpponent
        }
        
        socket.on("userDisconnected") { [weak self] (data, ack) in
            if let message = data.first as? String {
                if let currentSocketID = self?.socket.sid, message.contains(currentSocketID) {
                    print("client => this user disconnected: \(message)")
                    self?.gameState = .disconnected
                } else {
                    print("client => other user disconnected: \(message)")
                    self?.gameState = .waitingForOpponent
                }
            }
        }
    }

    func establishConnection() {
        gameState = .connectingToServer
        addEventListeners()
        socket.connect()
    }
    
    func closeConnection() {
        self.gameState = .disconnected
        guard let namespace = namespace else {
            socket.disconnect()
            return
        }
        socket.emit("disconnectNamespace", namespace)
        socket.disconnect()
    }
    
    func joinGame(username: String) {
        socket.emit("joinGame", username)
    }

    func winGame() {
        socket.emit("winGame")
    }
    
    func listenForEvents() {
        socket.on("gameEvent") { data, _ in
            print("client => received event: gameEvent")
            if let event = data[0] as? String {
                print("client => received event name: \(event)")
            }
        }
    }
}
