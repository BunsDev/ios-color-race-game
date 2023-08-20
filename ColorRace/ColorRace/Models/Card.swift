//
//  Card.swift
//  ColorRace
//
//  Created by Anup D'Souza on 20/08/23.
//

import Foundation

struct Card {
    static let cardRanks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    static let cardSymbols = ["♠️", "♥️", "♦️", "♣️"]
}

struct CardSize {
    static let smallCard = (w: CGFloat(90), h: CGFloat(120))
    static let regularCard = (w: CGFloat(200), h: CGFloat(300))
}
