//
//  FallingTileBehavior.swift
//  ColorRace
//
//  Created by Anup D'Souza on 26/08/23.
//

import Foundation
import UIKit

class FallingTileBehavior: UIDynamicBehavior {
    private let gravity = UIGravityBehavior()
    private let collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = true
        return collider
    }()
    private let itemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.allowsRotation = true
        itemBehavior.elasticity = 0.20
        return itemBehavior
    }()

    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
    }
    
    func addItem(item: UIDynamicItem) {
        gravity.addItem(item)
        collider.addItem(item)
        itemBehavior.addItem(item)
        itemBehavior.addAngularVelocity(.random(in: -10...10), for: item)
    }
    
    func removeItem(item: UIDynamicItem) {
        gravity.removeItem(item)
        collider.removeItem(item)
        itemBehavior.removeItem(item)
    }
}
