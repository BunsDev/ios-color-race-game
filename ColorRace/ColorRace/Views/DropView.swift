//
//  DropView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 26/08/23.
//

import Foundation
import UIKit

extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}
class DropView: UIView {
    private let dropBehavior = FallingTileBehavior()
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    private let dropsPerRow = 3
    var animating: Bool = false {
        didSet {
            if animating {
                animator.addBehavior(dropBehavior)
            } else {
                animator.removeBehavior(dropBehavior)
            }
        }
    }
    
    private var dropSize: CGSize {
        let size = bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    func addDrop() {
        var frame = CGRect(origin: .zero, size: dropSize)
        frame.origin.x = CGFloat.random(max: dropsPerRow) * dropSize.width
        let drop = UIView(frame: frame)
        drop.backgroundColor = UIColor.orange
        addSubview(drop)
        dropBehavior.addItem(item: drop)
    }
}
