//
//  TileView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 27/08/23.
//

import UIKit

protocol TileViewDelegate: AnyObject {
    func tileView(_ tileView: TileView, didSelectColor color: UIColor)
}

class TileView: UIView {
    weak var delegate: TileViewDelegate?
    private var colorIndex = 0
    private var colors: [UIColor] = []

    init(frame: CGRect, colors: [UIColor], delegate: TileViewDelegate) {
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
        
        delegate?.tileView(self, didSelectColor: colors[colorIndex])
    }
}

//import SwiftUI
//
//struct TileView: View {
//    @State private var colorIndex = 0
//    let colors: [Color] = [.red, .green, .blue, .white]
//
//    var body: some View {
//        Rectangle()
//            .fill(colors[colorIndex])
//            .frame(width: 100, height: 100)
//            .onTapGesture {
//                colorIndex = (colorIndex + 1) % colors.count
//            }
//    }
//}
//
//struct TileView_Previews: PreviewProvider {
//    static var previews: some View {
//        TileView()
//    }
//}
