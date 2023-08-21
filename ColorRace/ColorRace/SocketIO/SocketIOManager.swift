//
//  SocketIOManager.swift
//  ColorRace
//
//  Created by Anup D'Souza on 17/08/23.
//

import Foundation
import SocketIO

class SocketIOManager {
    static let shared = SocketIOManager()
    private var manager: SocketManager
    private var socket: SocketIOClient
    private let socketURL = URL(string: "http://localhost:3000")!
    
    private init() {
        manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
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
                print("Received event: \(event)")
            }
        }
    }
}
