//
//  SocketIOManager.swift
//  ColorRace
//
//  Created by Anup D'Souza on 17/08/23.
//

import Foundation
import SocketIO

class SocketIOManager {

    private var manager: SocketManager?
    private var socket: SocketIOClient?
    private let socketURL = URL(string: "http://localhost:8080")!

    init(manager: SocketManager? = nil) {
        if let manager {
            self.manager = manager
        } else {
            self.manager = SocketManager(socketURL: socketURL, config: [.log(true), .compress])
        }
        let socket = manager?.defaultSocket
    }
}
