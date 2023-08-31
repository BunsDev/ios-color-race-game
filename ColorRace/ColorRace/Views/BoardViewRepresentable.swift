//
//  TileGridView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 27/08/23.
//

import Foundation
import UIKit
import SwiftUI

struct BoardViewRepresentable: UIViewRepresentable {
    typealias UIViewType = BoardView
    @Binding var isMatching: Bool
    @Binding var boardColors: [[UIColor]]
    
    func makeUIView(context: Context) -> BoardView {
        let boardView = BoardView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), boardColors: boardColors)
        boardView.addTiles()
        return boardView
    }

    func updateUIView(_ uiView: BoardView, context: Context) {
        if isMatching {
             applyGravityAndCollisionBehavior(to: uiView)
        }
    }

    private func applyGravityAndCollisionBehavior(to uiView: BoardView) {
        uiView.animating = true
    }
}
