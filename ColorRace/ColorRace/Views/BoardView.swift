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
}

class BoardView: UIView {
    weak var delegate: BoardViewDelegate?
    private let dropBehavior = FallingObjectBehavior()
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    
    private let tilesPerRow = 3
    private let tileSize = CGSize(width: 100, height: 100)
    private let tileContainerView = UIView()
    private let tileColors: [UIColor] = [
        GameColors.white(), GameColors.blue(), GameColors.orange(), GameColors.yellow(), GameColors.green(), GameColors.red()
    ]
    private var boardColors: [[UIColor]]

    init(frame: CGRect, boardColors: [[UIColor]]) {
        self.boardColors = boardColors
        super.init(frame: frame)
        self.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var animating: Bool = false {
        didSet {
            if animating {
                animator.addBehavior(dropBehavior)
            } else {
                animator.removeBehavior(dropBehavior)
            }
        }
    }
    
    override func layoutSubviews() {
        tileContainerView.center = self.center
    }
    
    func addTiles() {
        let tileSpacing: CGFloat = 10.0 // Adjust this value to control the spacing between tiles
        tileContainerView.frame = CGRect(origin: .zero, size: CGSize(width: tileSize.width * CGFloat(tilesPerRow) + tileSpacing * CGFloat(tilesPerRow - 1),
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
    
    private func showLosingAnimation() {
        for subview in tileContainerView.subviews {

            UIView.animate(withDuration: .random(in: 0...0.5)) {

                let originalCenter = CGPoint(x: subview.frame.midX, y: subview.frame.midY)
                var frame = subview.frame
                frame.size.width = frame.size.width / 2
                frame.size.height = frame.size.height / 2
                frame.origin.x = originalCenter.x - frame.size.width / 2
                frame.origin.y = originalCenter.y - frame.size.height / 2
                subview.frame = frame

            } completion: { [weak self] finished in

                guard let self = self else { return }
                self.dropBehavior.addItem(item: subview)
            }
        }
    }
    
    private func showWinningAnimation() {
        
        for subview in tileContainerView.subviews {

            let confettiView = ConfettiView()
            confettiView.confettiColor = subview.backgroundColor
            confettiView.translatesAutoresizingMaskIntoConstraints = false
            subview.addSubview(confettiView)
            NSLayoutConstraint.activate([
                confettiView.leadingAnchor.constraint(equalTo: subview.leadingAnchor),
                confettiView.trailingAnchor.constraint(equalTo: subview.trailingAnchor),
                confettiView.topAnchor.constraint(equalTo: subview.topAnchor),
                confettiView.bottomAnchor.constraint(equalTo: subview.centerYAnchor)])
            
            UIView.animate(withDuration: .random(in: 0...1)) {
                 subview.alpha = 0
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    confettiView.removeFromSuperview()
                }
            }
        }
    }
}

extension BoardView: BoardTileViewDelegate {
    func boardTileView(_ tileView: UIView, didSelectColor color: UIColor) {
        let tileIndex = tileContainerView.subviews.firstIndex(of: tileView)
        guard let index = tileIndex else { return }

        let row = index / tilesPerRow
        let col = index % tilesPerRow

        if boardColors[row][col] == color {
            // TODO: update to get the currentcolor from tile view
            let allMatch = tileContainerView.subviews.enumerated().allSatisfy { (index, subview) in
                let row = index / tilesPerRow
                let col = index % tilesPerRow
                return boardColors[row][col] == subview.backgroundColor
            }

            if allMatch {
                showWinningAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in // allow for animation to complete
                    self?.delegate?.userWon()
                }
                // TODO: Be notified of losing event
            }
        }
    }
}
