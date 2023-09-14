//
//  Card.swift
//  ColorRace
//
//  Created by Anup D'Souza on 20/08/23.
//

import SwiftUI

protocol CardProps {
    var width: CGFloat { get }
    var height: CGFloat { get }
    var color: Color { get }
    var cornerRadius: CGFloat { get }
    var borderWidth: CGFloat { get }
    var borderColor: Color { get }
}

protocol CardBackDrawable {
    var text: String { get }
    var font: Font { get }
    var textColor: Color { get }
    var innerCornerRadius: CGFloat { get }
    var innerBorderColor: Color { get }
    var innerBorderWidth: CGFloat { get }
}

protocol CardFaceDrawable {
    var letter: String { get }
    var suit: String { get }
    var fontSize: CGFloat { get }
    var type: CardType { get }
    var colors: [[UIColor]] { get }
}

struct CardBack: CardBackDrawable {
    var text: String
    var font: Font
    var textColor: Color
    var innerCornerRadius: CGFloat
    var innerBorderColor: Color
    var innerBorderWidth: CGFloat
}

struct CardFace: CardFaceDrawable {
    var letter: String
    var suit: String
    var fontSize: CGFloat
    var colors: [[UIColor]]
    var type: CardType
}

enum CardRenderer {
    case face(drawable: CardFace)
    case back(drawable: CardBack)
}

struct CardLayout: CardProps {
    var width: CGFloat
    var height: CGFloat
    var color: Color
    var cornerRadius: CGFloat
    var borderWidth: CGFloat
    var borderColor: Color
}

struct CardDesign {
    var layout: CardLayout
    var renderer: CardRenderer
}

enum CardType {
    case small
    case medium
    case standard
}

struct CardDetail {
    static let letters = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    static let suits = ["suit.spade.fill", "suit.heart.fill", "suit.diamond.fill", "suit.club.fill"]
}

