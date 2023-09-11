//
//  GameUx.swift
//  ColorRace
//
//  Created by Anup D'Souza on 29/08/23.
//

import Foundation
import SwiftUI

internal struct GameUx {
    
    static func fontWithSize(_ size: CGFloat) -> Font {
        Font.custom(GameFontConfig.font, size: size)
    }

    static func titleFont() -> Font {
        Font.custom(GameFontConfig.font, size: GameFontConfig.titleFontSize)
    }

    static func subtitleFont() -> Font {
        Font.custom(GameFontConfig.font, size: GameFontConfig.subtitleFontSize)
    }

    static func buttonFont() -> Font {
        Font.custom(GameFontConfig.font, size: GameFontConfig.buttonFontSize)
    }

    static func navigationFont() -> UIFont {
        return .systemFont(ofSize: GameFontConfig.subtitleFontSize)
//        guard let font = UIFont(name: GameFontConfig.font, size: GameFontConfig.subtitleFontSize) else {
//            return .systemFont(ofSize: GameFontConfig.subtitleFontSize)
//        }
//        return font
    }
}
