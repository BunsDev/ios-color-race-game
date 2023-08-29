//
//  BoardView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 27/08/23.
//

import Foundation
import UIKit

class BoardView: UIView {
    
    private let dropBehavior = FallingTileBehavior()
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    
    private let tilesPerRow = 3
    private let tileSize = CGSize(width: 100, height: 100)
    private let tileContainerView = UIView()
    private let tileColors: [UIColor] = [.red, .blue, .orange, .yellow, .green, .white]
//    private var targetColors: [[UIColor]] = []
    private var targetColors: [[UIColor]] = [[.red, .red, .red],[.blue, .blue, .blue], [.orange, .orange, .orange]]
    
    var animating: Bool = false {
        didSet {
            if animating {
                //animator.addBehavior(dropBehavior)
                //shrinkAndDropTiles()
                explodeTiles()
            } else {
                animator.removeBehavior(dropBehavior)
            }
        }
    }
    
    override func layoutSubviews() {
        tileContainerView.center = self.center
    }
    
    func addTiles() {
        generateRandomTargetColors()
        tileContainerView.frame = CGRect(origin: .zero, size: CGSize(width: tileSize.width * CGFloat(tilesPerRow), height: tileSize.height * CGFloat(tilesPerRow)))
        for row in 0..<tilesPerRow {
            for col in 0..<tilesPerRow {
                let frame = CGRect(
                    x: CGFloat(col) * tileSize.width,
                    y: CGFloat(row) * tileSize.width,
                    width: tileSize.width,
                    height: tileSize.height
                )
                let tileView = TileView(frame: frame, colors: tileColors, delegate: self)
                tileView.backgroundColor = tileColors.randomElement() // TODO: remove
                tileContainerView.addSubview(tileView)
            }
        }
        addSubview(tileContainerView)
        tileContainerView.center = self.center
    }
    
    private func generateRandomTargetColors() {
//        targetColors = (0..<tilesPerRow).map { _ in
//            return (0..<tilesPerRow).map { _ in
//                return tileColors.randomElement() ?? .white
//            }
//        }
        print(targetColors)
    }
    
    private func shrinkAndDropTiles() {
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
    
    private func explodeTiles() {
        for subview in tileContainerView.subviews {

            let explosionEmitter = CAEmitterLayer()
            explosionEmitter.emitterShape = .rectangle
            explosionEmitter.emitterPosition = subview.center
            explosionEmitter.emitterSize = subview.bounds.size

            var cells = [CAEmitterCell]()
            for color in self.tileColors {
                cells.append(self.confettiWithColor(color: color))
            }

            explosionEmitter.emitterCells = cells
            subview.layer.addSublayer(explosionEmitter)

            UIView.animate(withDuration: .random(in: 0...1)) {
                 subview.alpha = 0
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    explosionEmitter.removeFromSuperlayer()
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

extension BoardView: TileViewDelegate {
    func tileView(_ tileView: TileView, didSelectColor color: UIColor) {
        let tileIndex = tileContainerView.subviews.firstIndex(of: tileView)
        guard let index = tileIndex else { return }

        let row = index / tilesPerRow
        let col = index % tilesPerRow

        if targetColors[row][col] == color {
            let allMatch = tileContainerView.subviews.enumerated().allSatisfy { (index, subview) in
                let row = index / tilesPerRow
                let col = index % tilesPerRow
                return targetColors[row][col] == subview.backgroundColor
            }

            if allMatch {
                print("WON!")
                explodeTiles()
            }
        }
    }
}

extension UIImage {
    static func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
