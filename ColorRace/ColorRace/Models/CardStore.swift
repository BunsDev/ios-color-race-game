//
//  CardStore.swift
//  ColorRace
//
//  Created by Anup D'Souza on 30/08/23.
//

import Foundation
import UIKit

struct CardStore {
    static let mediumCardLayout = CardLayout(width: 90, height: 155, color: .white, cornerRadius: 5, borderWidth: 1, borderColor: .black)
    static let standardCardLayout = CardLayout(width: 200, height: 330, color: .white, cornerRadius: 15, borderWidth: 2, borderColor: .black)
    
    static let mediumCardBack = CardBack(text: "CR", font: GameUx.subtitleFont(), textColor: .black, innerCornerRadius: 5, innerBorderColor: .black, innerBorderWidth: 1)
    static let mediumCardBackView = CardView(cardDesign: CardDesign(layout: mediumCardLayout, renderer: .back(drawable: mediumCardBack)))
    
    static let standardCardBack = CardBack(text: "CR", font: GameUx.titleFont(), textColor: .black, innerCornerRadius: 15, innerBorderColor: .black, innerBorderWidth: 2)
    static let standardCardBackView = CardBackView(cardLayout: standardCardLayout, cardBack: standardCardBack, degree: .constant(0))
    
    static let mediumCardFace = CardFace(letter: "A", suit: "♠️", fontSize: 10, type: .medium)
    static let mediumCardFaceView = CardFaceView(cardLayout: mediumCardLayout, cardFace: mediumCardFace, degree: .constant(0))
    
    static let standardCardFace = CardFace(letter: "A", suit: "♣️", fontSize: 20, type: .standard)
    static let standardCardFaceView = CardFaceView(cardLayout: standardCardLayout, cardFace: standardCardFace, degree: .constant(0))
    
    static let defaultBoardColors: [[UIColor]] = Array(repeating: Array(repeating: UIColor.white, count: 3), count: 3)// [[.white, .white, .white], [.white, .white, .white], [.white, .white, .white]]
}
