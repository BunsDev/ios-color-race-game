//
//  ConfettiView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 08/09/23.
//

import UIKit

class ConfettiView: UIView {

    var confettiColor: UIColor?
    
    override class var layerClass:AnyClass {
        return CAEmitterLayer.self
    }

    override func layoutSubviews() {
        let emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        emitter.emitterSize = CGSize(width: bounds.size.width * 0.50, height: 1.0)
        emitter.renderMode = .additive
        emitter.emitterCells = [confettiWithColor()]
    }

    private func confettiWithColor() -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.color = confettiColor?.cgColor
        confetti.birthRate = 10.0
        confetti.lifetime = 1.0
        confetti.velocity = 150
        confetti.emissionLongitude = CGFloat.pi
        confetti.emissionRange = CGFloat.pi * 2
        confetti.spin = 2
        confetti.contents = UIImage.imageWithColor(.white, size: CGSize(width: 5, height: 5)).cgImage
        return confetti
    }
}
