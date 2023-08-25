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
    private let loggingEnabled: Bool = false
    
    private init() {
        manager = SocketManager(socketURL: socketURL, config: [.log(loggingEnabled), .compress])
        socket = manager.defaultSocket
    }

    private func addEventListeners() {
        
        socket.on(SocketEvents.userConnected) { [weak self] data, _ in
            guard let data = data.first as? String else {
                print("client => received event: \(SocketEvents.userConnected), failed to read namespace")
                return
            }
            print("client => received event: \(SocketEvents.userConnected), namespace: \(data)")
            self?.namespace = data
            self?.gameState = .waitingForOpponent
        }
        
        socket.on(SocketEvents.userJoined) { [weak self] data, _ in
            guard let data = data.first as? String else {
                print("client => received event: \(SocketEvents.userJoined), failed to read user socket id")
                return
            }
            if let socketId = self?.socket.sid, socketId == data {
                print("client => received event: \(SocketEvents.userJoined), socket id(self):\(data)")
                self?.gameState = .waitingForOpponent
            } else {
                print("client => received event: \(SocketEvents.userJoined), socket id(other):\(data)")
                if self?.gameState != .inGame {
                    self?.gameState = .waitingForOpponent
                }
            }
        }
        
        socket.on(SocketEvents.gameStarted) { [weak self] data, _ in
            guard let data = data.first as? String else {
                print("client => received event: \(SocketEvents.gameStarted), failed to read namespace")
                return
            }
            
            if let namespace = self?.namespace, namespace == data {
                print("client => received event: \(SocketEvents.gameStarted), namespace(self):\(data)")
                self?.gameState = .inGame
            } else {
                print("client => received event: \(SocketEvents.gameStarted), namespace(other):\(data)")
                self?.gameState = .waitingForOpponent
            }
        }
        
        socket.on(SocketEvents.userDisconnected) { [weak self] data, _ in
            guard let data = data.first as? String else {
                print("client => received event: \(SocketEvents.userDisconnected), failed to read namespace")
                return
            }
            
            if let socketId = self?.socket.sid, socketId == data {
                print("client => received event: \(SocketEvents.userDisconnected), socket id(self):\(data)")
                self?.namespace = nil
                self?.gameState = .disconnected
            } else {
                print("client => received event: \(SocketEvents.userDisconnected), socket id(other):\(data)")
                self?.gameState = .waitingForOpponent
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
    
    private func isUserConnected() -> Bool {
        return true
    }
}
