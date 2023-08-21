//
//  Card.swift
//  ColorRace
//
//  Created by Anup D'Souza on 20/08/23.
//

import SwiftUI

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
}

struct CardDetail {
    static let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    static let symbols = ["♠️", "♥️", "♦️", "♣️"]
}

struct CardStore {
    static let small: Card = Card(width: 30, height: 45, faceColor: .white, backColor: .purple, faceFontSize: 5, backFontSize: 10, rank: CardDetail.ranks.randomElement()!, symbol: CardDetail.symbols.randomElement()!, isFaceUp: false)
    static let medium: Card = Card(width: 90, height: 150, faceColor: .white, backColor: .purple, faceFontSize: 10, backFontSize: 20, rank: CardDetail.ranks.randomElement()!, symbol: CardDetail.symbols.randomElement()!, isFaceUp: false)
    static let standard: Card = Card(width: 200, height: 300, faceColor: .white, backColor: .purple, faceFontSize: 20, backFontSize: 40, rank: CardDetail.ranks.randomElement()!, symbol: CardDetail.symbols.randomElement()!, isFaceUp: true)
}

