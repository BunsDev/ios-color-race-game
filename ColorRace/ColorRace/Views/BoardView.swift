//
//  BoardView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 27/08/23.
//

import Foundation
import UIKit

protocol BoardViewDelegate: AnyObject {
    func userWon()
    func userTappedTile(row: Int, col: Int, color: UIColor)
}

class BoardView: UIView {
    weak var delegate: BoardViewDelegate?
    private let tilesPerRow = 3
    private let tileSize = CGSize(width: 100, height: 100)
    private let tileContainerView = UIView()
    private let tileColors: [UIColor] = GameColors.allColors()
    private var boardColors: [[UIColor]]

    init(frame: CGRect, boardColors: [[UIColor]]) {
        self.boardColors = boardColors
        super.init(frame: frame)
        self.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        tileContainerView.center = self.center
    }
    
    func addTiles() {
        let tileSpacing: CGFloat = 10.0
        tileContainerView.frame = CGRect(origin: .zero,
                                         size: CGSize(width: tileSize.width * CGFloat(tilesPerRow) + tileSpacing * CGFloat(tilesPerRow - 1),
                                                      height: tileSize.height * CGFloat(tilesPerRow) + tileSpacing * CGFloat(tilesPerRow - 1)))
        for row in 0..<tilesPerRow {
            for col in 0..<tilesPerRow {
                let frame = CGRect(
                    x: CGFloat(col) * (tileSize.width + tileSpacing),
                    y: CGFloat(row) * (tileSize.height + tileSpacing),
                    width: tileSize.width,
                    height: tileSize.height
                )
                let tileView = BoardTileView(frame: frame, colors: tileColors, delegate: self)
                tileContainerView.addSubview(tileView)
            }
        }
        addSubview(tileContainerView)
        tileContainerView.center = self.center
    }
}

extension BoardView: BoardTileViewDelegate {
    func boardTileView(_ tileView: UIView, didSelectColor color: UIColor) {
        let tileIndex = tileContainerView.subviews.firstIndex(of: tileView)
        guard let index = tileIndex else { return }

        let row = index / tilesPerRow
        let col = index % tilesPerRow
        print("selected tile [\(row)][\(col)]")
        self.delegate?.userTappedTile(row: row, col: col, color: color)
        
        if boardColors[row][col] == color {

            let allMatch = tileContainerView.subviews.enumerated().allSatisfy { (index, subview) in
                let row = index / tilesPerRow
                let col = index % tilesPerRow
                return boardColors[row][col] == (subview as? BoardTileView)?.currentColor
            }

            if allMatch {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.userWon()
                }
            }
        }
    }
}
