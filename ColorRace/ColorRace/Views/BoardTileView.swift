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
    weak var delegate: BoardTileViewDelegate?
    private var colorIndex = 0
    private var colors: [UIColor] = []
    private var gradientLayer: CAGradientLayer!
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
        addSubview(tileShadowView)
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: tileShadowView.bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            shadowLayer.shadowOpacity = 0.3
            shadowLayer.shadowRadius = 5
            tileShadowView.layer.addSublayer(shadowLayer)
        }
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
        self.setBackground(.white)
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        colorIndex = (colorIndex + 1) % colors.count
        self.setBackground(colors[colorIndex])
        
        delegate?.boardTileView(tileView, didSelectColor: colors[colorIndex])
        
        //self.showAnimation {}
    }
    
    private func setBackground(_ color: UIColor) {
        currentColor = color
        tileView.backgroundColor = currentColor
        
        if gradientLayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = tileView.bounds
        
        if currentColor == UIColor.blue {
            gradientLayer.colors = [
                UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1.0).cgColor,
                UIColor(red: 77/255, green: 85/255, blue: 240/255, alpha: 1.0).cgColor
            ]
        } else if currentColor == UIColor.orange {
            gradientLayer.colors = [
                UIColor(red: 248/255, green: 196/255, blue: 119/255, alpha: 1.0).cgColor,
                UIColor(red: 251/255, green: 161/255, blue: 26/255, alpha: 1.0).cgColor
            ]
        } else if currentColor == UIColor.yellow {
            gradientLayer.colors = [
                UIColor(red: 236/255, green: 238/255, blue: 130/255, alpha: 1.0).cgColor,
                UIColor(red: 230/255, green: 234/255, blue: 32/255, alpha: 1.0).cgColor
            ]
        } else if currentColor == UIColor.green {
            gradientLayer.colors = [
                UIColor(red: 121/255, green: 223/255, blue: 156/255, alpha: 1.0).cgColor,
                UIColor(red: 85/255, green: 170/255, blue: 104/255, alpha: 1.0).cgColor
            ]
        } else if currentColor == UIColor.red {
            gradientLayer.colors = [
                UIColor(red: 221/255, green: 113/255, blue: 130/255, alpha: 1.0).cgColor,
                UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 1.0).cgColor
            ]
        } else { // white
            gradientLayer.colors = [
                UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor,
                UIColor(red: 249/255, green: 249/255, blue: 255/255, alpha: 1.0).cgColor
            ]
        }

        tileView.layer.addSublayer(gradientLayer)
    }
}
