//
//  Card.swift
//  ColorRace
//
//  Created by Anup D'Souza on 20/08/23.
//

import SwiftUI

internal enum CardType {
    case small
    case medium
    case standard
}

protocol CardConfiguration {
    var width: CGFloat { get }
    var height: CGFloat { get }
    var faceColor: Color { get }
    var backColor: Color { get }
    var isFaceUp: Bool { get set }
    var faceFontSize: CGFloat { get set }
    var backFontSize: CGFloat { get set }
    var rank: String { get set }
    var symbol: String { get set }
    var type: CardType { get }
}

struct Card: CardConfiguration {
    var width: CGFloat
    var height: CGFloat
    var faceColor: Color
    var backColor: Color
    var faceFontSize: CGFloat
    var backFontSize: CGFloat
    var rank: String
    var symbol: String
    var isFaceUp: Bool
    var type: CardType
}

struct CardDetail {
    static let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    static let symbols = ["♠️", "♥️", "♦️", "♣️"]
}

struct CardStore {
    static let small: Card = Card(width: 50, height: 50, faceColor: .white, backColor: .purple, faceFontSize: 0, backFontSize: 10, rank: CardDetail.ranks.randomElement()!, symbol: CardDetail.symbols.randomElement()!, isFaceUp: false, type: .small)
    static let medium: Card = Card(width: 90, height: 155, faceColor: .white, backColor: .purple, faceFontSize: 10, backFontSize: 20, rank: CardDetail.ranks.randomElement()!, symbol: CardDetail.symbols.randomElement()!, isFaceUp: false, type: .medium)
    static let standard: Card = Card(width: 200, height: 330, faceColor: .white, backColor: .purple, faceFontSize: 20, backFontSize: 40, rank: CardDetail.ranks.randomElement()!, symbol: CardDetail.symbols.randomElement()!, isFaceUp: false, type: .standard)
    
    func standardCard() -> Card {
        Card(width: 200, height: 300, faceColor: .white, backColor: .purple, faceFontSize: 20, backFontSize: 40, rank: CardDetail.ranks.randomElement()!, symbol: CardDetail.symbols.randomElement()!, isFaceUp: false, type: .standard)
    }
}

