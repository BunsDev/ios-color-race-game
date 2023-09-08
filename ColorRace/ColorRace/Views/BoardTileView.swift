//
//  BoardTileView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 27/08/23.
//

import UIKit

protocol BoardTileViewDelegate: AnyObject {
    func boardTileView(_ tileView: BoardTileView, didSelectColor color: UIColor)
}

class BoardTileView: UIView {
    weak var delegate: BoardTileViewDelegate?
    private var colorIndex = 0
    private var colors: [UIColor] = []

    init(frame: CGRect, colors: [UIColor], delegate: BoardTileViewDelegate) {
        super.init(frame: frame)
        self.colors = colors
        self.delegate = delegate
        self.backgroundColor = .white
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        colorIndex = (colorIndex + 1) % colors.count
        self.backgroundColor = colors[colorIndex]
        
        delegate?.boardTileView(self, didSelectColor: colors[colorIndex])
    }
}
