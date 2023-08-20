//
//  Card.swift
//  ColorRace
//
//  Created by Anup D'Souza on 20/08/23.
//

import SwiftUI

// TODO: Update to card configuration
protocol PlayingCard {
    var width: CGFloat { get }
    var height: CGFloat { get }
    var faceColor: Color { get }
    var backColor: Color { get }
    var isFaceUp: Bool { get set }
}

struct StandardCard: PlayingCard {
    var width: CGFloat
    var height: CGFloat
    var faceColor: Color
    var backColor: Color
    var isFaceUp: Bool
}

// TODO: Small & Medium cards

struct Card {
    static let cardRanks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    static let cardSymbols = ["♠️", "♥️", "♦️", "♣️"]
    static let smallCard = (w: CGFloat(90), h: CGFloat(120))
    static let standard: StandardCard = StandardCard(width: 200, height: 300, faceColor: .white, backColor: .purple, isFaceUp: false)
}
