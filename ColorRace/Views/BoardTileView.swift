//
//  BoardTileView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 27/08/23.
//

import UIKit

protocol BoardTileViewDelegate: AnyObject {
    func boardTileView(_ tileView: UIView, didSelectColor color: UIColor)
}

class BoardTileView: UIView {
    private weak var delegate: BoardTileViewDelegate?
    private var colorIndex = 0
    private var colors: [UIColor] = []
    private var shadowLayer: CAShapeLayer!
    private let cornerRadius: CGFloat = 10
    private var tileView: UIView!
    private var tileShadowView: UIView!
    private(set) var currentColor: UIColor!
    
    init(frame: CGRect, colors: [UIColor], delegate: BoardTileViewDelegate) {
        super.init(frame: frame)
        self.colors = colors
        self.delegate = delegate
        backgroundColor = .clear
        layer.masksToBounds = false
        
        addShadow()
        addTile()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addShadow() {
        tileShadowView = UIView(frame: CGRect(origin: .zero, size: frame.size))
        tileShadowView.backgroundColor = .clear
        
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: tileShadowView.bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 5
        tileShadowView.layer.addSublayer(shadowLayer)
        
        addSubview(tileShadowView)
    }
    
    private func addTile() {
        tileView = UIView(frame: CGRect(origin: .zero, size: frame.size))
        tileView.backgroundColor = .clear
        tileView.layer.borderWidth = 0.5
        tileView.layer.borderColor = UIColor.white.cgColor
        tileView.layer.cornerRadius = cornerRadius
        tileView.layer.masksToBounds = true
        tileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        addSubview(tileView)
        currentColor = GameColors.white()
        tileView.backgroundColor = currentColor
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        colorIndex = (colorIndex + 1) % colors.count
        let color = colors[colorIndex]
        currentColor = color
        UIView.animate(withDuration: 0.05) { [weak self] in
            guard let self = self else { return }
            self.tileView.backgroundColor = color
            self.transform = CGAffineTransformMakeScale(0.95, 0.95)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.boardTileView(self, didSelectColor: color)
            self.transform = .identity
        }
    }
}
