//
//  BoardView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 27/08/23.
//

import Foundation
import UIKit

class BoardView: UIView {
    
    private let dropBehavior = FallingObjectBehavior()
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    
    private let tilesPerRow = 3
    private let tileSize = CGSize(width: 100, height: 100)
    private let tileContainerView = UIView()
    private let tileColors: [UIColor] = [.red, .blue, .orange, .yellow, .green, .white]
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
        tileContainerView.frame = CGRect(origin: .zero, size: CGSize(width: tileSize.width * CGFloat(tilesPerRow),
                                                                     height: tileSize.height * CGFloat(tilesPerRow)))
        for row in 0..<tilesPerRow {
            for col in 0..<tilesPerRow {
                let frame = CGRect(
                    x: CGFloat(col) * tileSize.width,
                    y: CGFloat(row) * tileSize.width,
                    width: tileSize.width,
                    height: tileSize.height
                )
                let tileView = BoardTileView(frame: frame, colors: tileColors, delegate: self)
                tileView.backgroundColor = .white
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

            let confettiEmitter = CAEmitterLayer()
            confettiEmitter.emitterShape = .rectangle
            confettiEmitter.emitterPosition = subview.center
            confettiEmitter.emitterSize = subview.bounds.size

            var confettiCells = [CAEmitterCell]()
            for color in self.tileColors {
                confettiCells.append(self.confettiWithColor(color: color))
            }

            confettiEmitter.emitterCells = confettiCells
            subview.layer.addSublayer(confettiEmitter)

            UIView.animate(withDuration: .random(in: 0...1)) {
                 subview.alpha = 0
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    confettiEmitter.removeFromSuperlayer()
                }
            }
        }
    }

    private func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.color = color.cgColor
        confetti.birthRate = 5.0
        confetti.lifetime = 5.0
        confetti.velocity = 150
        confetti.emissionLongitude = CGFloat.pi
        confetti.emissionRange = CGFloat.pi * 2
        confetti.spin = 3.5
        confetti.spinRange = 1
        confetti.scaleRange = 0.5
        confetti.scaleSpeed = -0.1
        confetti.contents = UIImage.imageWithColor(.white, size: CGSize(width: 5, height: 5)).cgImage
        return confetti
    }
}

extension BoardView: BoardTileViewDelegate {
    func boardTileView(_ tileView: BoardTileView, didSelectColor color: UIColor) {
        let tileIndex = tileContainerView.subviews.firstIndex(of: tileView)
        guard let index = tileIndex else { return }

        let row = index / tilesPerRow
        let col = index % tilesPerRow

        if boardColors[row][col] == color {
            let allMatch = tileContainerView.subviews.enumerated().allSatisfy { (index, subview) in
                let row = index / tilesPerRow
                let col = index % tilesPerRow
                return boardColors[row][col] == subview.backgroundColor
            }

            if allMatch {
                showWinningAnimation()
                // TODO: Notify GameView of winning event
                // TODO: Be notified of losing event
            }
        }
    }
}
