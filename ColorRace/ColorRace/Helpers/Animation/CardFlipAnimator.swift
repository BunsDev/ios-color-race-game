//
//  CardFlipAnimator.swift
//  ColorRace
//
//  Created by Anup D'Souza on 02/09/23.
//

import Foundation
import SwiftUI

class CardFlipAnimator: ObservableObject {
    @Published var backDegree = 0.0
    @Published var frontDegree = -90.0
    private let durationAndDelay: CGFloat = 0.25
    
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
