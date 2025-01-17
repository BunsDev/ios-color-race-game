//
//  GameManager.swift
//  ColorRace
//
//  Created by Anup D'Souza on 29/08/23.
//

import Foundation
import SwiftUI
import Combine
import SocketIO

// TODO: disconnect user on backgrounding the app
final class GameManager: ObservableObject {
    /// Game management
    @Published private(set) var gameState: GameState
    private var cancellable: AnyCancellable?
    @Published private(set) var secondsToNextRound: Int = 3
    var timer = Timer()
    
    /// SocketManager
    private var socketManager: SocketManager?
    private var socket: SocketIOClient?
    private let socketURL = URL(string: "http://localhost:3000")!
    private var namespace: String?
    private let loggingEnabled: Bool = false
    @Published private var socketState = SocketState.disconnected
    
    /// Game board
    private let boardTileColors: [UIColor] = GameColors.paletteColors()
    var boardColors: [[UIColor]] = []
    @Published var opponentColors: [[UIColor]] = GameColors.defaultColors()
    
    init() {
        self.socketManager = SocketManager(socketURL: socketURL, config: [.log(loggingEnabled), .compress])
        self.socket = socketManager?.defaultSocket
        self.gameState = .disconnected(text: GameStrings.joinGame)
        self.cancellable = $socketState
            .sink { [weak self] socketState in
                print("gm: received socket event: \(socketState)")
                self?.updateGameState(forSocketState: socketState)
            }
    }
    
    deinit {
        cancellable?.cancel()
        cancellable = nil
        socketManager = nil
        socket = nil
    }
}

extension GameManager {
    
    func joinGame() {
        closeConnection()
        establishConnection()
    }
    
    func quitGame() {
        closeConnection()
    }
    
    func preparedGame() {
        gameState = .playing
    }
    
    func userWonGame() {
        gameState = .userWon
        userWonOnConnection()
        startNextRoundTimer()
    }
    
    func userLostGame() {
        startNextRoundTimer()
    }
    
    func userSelection(_ selection: TileSelection) {
        sendUserSelectionOnConnection(selection)
    }
    
    private func startNextRoundTimer() {
        secondsToNextRound = 3
        stopNextRoundTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateNextRoundTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateNextRoundTimer() {
        guard secondsToNextRound > 0 else {
            stopNextRoundTimer()
            loadNextRound()
            return
        }
        
        secondsToNextRound -= 1
    }
    
    private func stopNextRoundTimer() {
        timer.invalidate()
    }
    
    private func loadNextRound() {
        setupBoard()
        gameState = .preparingGame(text: GameStrings.opponentFound)
    }
    
    private func setupBoard() {
        generateRandomBoardColors()
    }
    
    private func generateRandomBoardColors() {
        boardColors = (0..<3).map { _ in
            return (0..<3).map { _ in
                return boardTileColors.randomElement() ?? .white
            }
        }
        print(boardColors)
    }
    
    private func updateGameState(forSocketState socketState: SocketState) {

        switch socketState {
            
        case .disconnected, .userDisconnected:
            gameState = .disconnected(text: GameStrings.joinGame)
            
        case .userConnected, .userJoined, .opponentDisconnected:
            gameState = .connectingToOpponent(text: GameStrings.waitingForOpponent)
            
        case .opponentJoined:
            gameState = gameState.userIsInGame ? gameState : .connectingToOpponent(text: GameStrings.waitingForOpponent)

        case .gameStarted:
            setupBoard()
            gameState = .preparingGame(text: GameStrings.opponentFound)
            
        case .connectingToServer:
            gameState = .connectingToServer(text: GameStrings.connectingToServer)
            
        case .userLost:
            gameState = .userLost
            userLostGame()
        }
    }
}

extension GameManager {
    
    private func addEventListeners() {
        
        socket?.on(SocketEvents.userConnected) { [weak self] data, _ in
            guard let data = data.first as? String else {
                print("client => received event: \(SocketEvents.userConnected), failed to read namespace")
                return
            }
            print("client => received event: \(SocketEvents.userConnected), namespace: \(data)")
            self?.namespace = data
            self?.socketState = .userConnected
        }
        
        socket?.on(SocketEvents.userJoined) { [weak self] data, _ in
            guard let data = data.first as? String else {
                print("client => received event: \(SocketEvents.userJoined), failed to read user socket id")
                return
            }
            if let socketId = self?.socket?.sid, socketId == data {
                print("client => received event: \(SocketEvents.userJoined), socket id(self):\(data)")
                self?.socketState = .userJoined
            } else {
                print("client => received event: \(SocketEvents.userJoined), socket id(other):\(data)")
                self?.socketState = .opponentJoined
            }
        }
        
        socket?.on(SocketEvents.gameStarted) { [weak self] data, _ in
            guard let data = data.first as? String else {
                print("client => received event: \(SocketEvents.gameStarted), failed to read namespace")
                return
            }
            
            if let namespace = self?.namespace, namespace == data {
                print("client => received event: \(SocketEvents.gameStarted), namespace(self):\(data)")
                self?.socketState = .gameStarted
            } else {
                print("client => received event: \(SocketEvents.gameStarted), namespace(other):\(data)")
                self?.socketState = .gameStarted
            }
        }
        
        socket?.on(SocketEvents.userDisconnected) { [weak self] data, _ in
            guard let data = data.first as? String else {
                print("client => received event: \(SocketEvents.userDisconnected), failed to read namespace")
                return
            }
            
            if let socketId = self?.socket?.sid, socketId == data {
                print("client => received event: \(SocketEvents.userDisconnected), socket id(self):\(data)")
                self?.namespace = nil
                self?.socketState = .userDisconnected
            } else {
                print("client => received event: \(SocketEvents.userDisconnected), socket id(other):\(data)")
                self?.socketState = .opponentDisconnected
            }
        }
        
        socket?.on(SocketEvents.userWon) { [weak self] data, _ in
            guard let data = data.first as? String else {
                print("client => received event: \(SocketEvents.userWon), failed to read namespace")
                return
            }
            
            if let socketId = self?.socket?.sid, socketId == data {
                print("client => received event: \(SocketEvents.userWon), socket id(self):\(data)")
                // this user won, do nothing
            } else {
                print("client => received event: \(SocketEvents.userWon), socket id(other):\(data)")
                self?.socketState = .userLost
            }
        }

        socket?.on(SocketEvents.userSelection) { [weak self] data, _ in
            guard let data = data.first as? [String: Any], let namespace = data["namespace"] else {
                print("client => received event: \(SocketEvents.userWon), failed to read namespace")
                return
            }
            
            if let socketId = self?.socket?.sid, socketId == data["socketId"] as? String {
                print("client => received event: \(SocketEvents.userSelection), socket id(self):\(data)")
            } else {
                if let row = data["row"] as? Int, let col = data["col"] as? Int, let color = data["color"] as? String {
                    print("client => received event: \(SocketEvents.userSelection), socket id(other):\(data)")
                    self?.opponentColors[row][col] = UIColor(hexString: color) ?? .white
                }
            }
        }
    }
    
    private func establishConnection() {
        socketState = .connectingToServer
        addEventListeners()
        socket?.connect()
    }
    
    private func closeConnection() {
        socketState = .disconnected
        guard let namespace = namespace else {
            socket?.disconnect()
            return
        }
        socket?.emit(SocketEvents.disconnectNamespace, namespace)
        socket?.disconnect()
    }
    
    private func userWonOnConnection() {
        guard let namespace = namespace else {
            socket?.disconnect()
            return
        }
        socket?.emit(SocketEvents.userWon, namespace)
    }
    
    private func sendUserSelectionOnConnection(_ selection: TileSelection) {
        guard let namespace = namespace else {
            socket?.disconnect()
            return
        }
        guard let colorAsHex = selection.color.toHex() else {
            return
        }

        let data = ["color": colorAsHex, "row": selection.row, "col": selection.col, "namespace": namespace] as [String : Any]
        socket?.emit(SocketEvents.userSelection, data)
    }
}
