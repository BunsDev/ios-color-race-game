//
//  CardFlipAnimator.swift
//  ColorRace
//
//  Created by Anup D'Souza on 02/09/23.
//

import Foundation
import SwiftUI

// TODO: Enhancements
// 1. notify caller on completion of flip

class CardFlipAnimator: ObservableObject {
    @Published var backDegree = 0.0
    @Published var frontDegree = -90.0
    @Published private var isFlipped = false
    @Published private var flipAnimationCompleted = false
    private let durationAndDelay: CGFloat = 0.3
    
    func flipCard () {
        withAnimation(.linear(duration: durationAndDelay)) {
            backDegree = 90
        }
        withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
            frontDegree = 0
        }
    }
    
    func setDefaults() {
        backDegree = 0.0
        frontDegree = -90.0
    }
}
