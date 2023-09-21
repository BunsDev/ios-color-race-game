//
//  BoardViewRepresentable.swift
//  ColorRace
//
//  Created by Anup D'Souza on 27/08/23.
//

import Foundation
import UIKit
import SwiftUI

struct BoardViewRepresentable: UIViewRepresentable {
    typealias UIViewType = BoardView
    @Binding var userWon: Bool
    @Binding var tileSelection: TileSelection
    @Binding var boardColors: [[UIColor]]
    
    func makeUIView(context: Context) -> BoardView {
        let boardView = BoardView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), boardColors: boardColors)
        boardView.delegate = context.coordinator
        boardView.addTiles()
        return boardView
    }

    func updateUIView(_ uiView: BoardView, context: Context) {
        print("updateUIView: \(userWon)")
    }

    func makeCoordinator() -> BoardViewCoordinator {
        BoardViewCoordinator(self)
    }

    class BoardViewCoordinator: BoardViewDelegate  {
        var parent: BoardViewRepresentable
        
        init(_ parent: BoardViewRepresentable) {
            self.parent = parent
        }

        func userWon() {
            self.parent.userWon = true
        }
        
        func userTappedTile(row: Int, col: Int, color: UIColor) {
            self.parent.tileSelection = TileSelection(row: row, col: col, color: color)
        }
    }
}
