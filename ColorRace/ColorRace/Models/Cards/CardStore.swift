//
//  CardStore.swift
//  ColorRace
//
//  Created by Anup D'Souza on 30/08/23.
//

import Foundation
import UIKit
import SwiftUI

struct CardStore {
    static let mediumCardLayout = CardLayout(width: 90, height: 155, color: .white, cornerRadius: 10, borderWidth: 1, borderColor: .black)
    static let standardCardLayout = CardLayout(width: 200, height: 330, color: .white, cornerRadius: 15, borderWidth: 2, borderColor: .black)
    
    static let mediumCardBack = CardBack(text: "CR", font: GameUx.subtitleFont(), textColor: .black, innerCornerRadius: 5, innerBorderColor: .black, innerBorderWidth: 5)
    static let mediumCardBackView = CardView(cardDesign: CardDesign(layout: mediumCardLayout, renderer: .back(drawable: mediumCardBack)))
    
    static let standardCardBack = CardBack(text: "CR", font: GameUx.titleFont(), textColor: .black, innerCornerRadius: 15, innerBorderColor: .black, innerBorderWidth: 2)
    static let standardCardBackView = CardBackView(cardLayout: standardCardLayout, cardBack: standardCardBack, degree: .constant(0))
    
    static let mediumCardFace = CardFace(letter: "A", suit: "♠️", fontSize: 10, colors: defaultBoardColors, type: .small)
    static let mediumCardFaceView = CardFaceView(cardLayout: mediumCardLayout, cardFace: mediumCardFace, degree: .constant(0))
    
    static let standardCardFace = CardFace(letter: "A", suit: "♣️", fontSize: 20, colors: defaultBoardColors, type: .standard)
    static let standardCardFaceView = CardFaceView(cardLayout: standardCardLayout, cardFace: standardCardFace, degree: .constant(0))
    
    static let defaultBoardColors: [[UIColor]] = Array(repeating: Array(repeating: UIColor.white, count: 3), count: 3)
    
    static func mediumCardFaceWithColors(_ colors: [[UIColor]]) -> CardFace {
        return CardFace(letter: CardDetail.letters.randomElement()!, suit: CardDetail.suits.randomElement()!, fontSize: 10, colors: colors, type: .medium)
    }

    static func loadingCards() -> [AnyView] {
        [
            AnyView(CardStore.mediumCardBackView),
            AnyView(CardStore.mediumCardBackView),
            AnyView(CardStore.mediumCardBackView)
        ]
    }
}
