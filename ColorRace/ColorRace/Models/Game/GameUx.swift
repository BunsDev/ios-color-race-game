//
//  GameUx.swift
//  ColorRace
//
//  Created by Anup D'Souza on 29/08/23.
//

import Foundation
import SwiftUI

struct GameFontConfig {
    static let font: String = "Handlee"
    static let titleFontSize: CGFloat = 50
    static let subtitleFontSize: CGFloat = 20
    static let buttonFontSize: CGFloat = 20
}

struct GameUx {
    
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
        guard let font = UIFont(name: GameFontConfig.font, size: GameFontConfig.subtitleFontSize) else {
            return .systemFont(ofSize: GameFontConfig.subtitleFontSize)
        }
        return font
    }
    
    static func background() -> Color {
        Color(uiColor: UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1.0))
    }
    
    static func brandColor() -> Color {
        Color(uiColor: brandUIColor())
    }
    
    static func brandUIColor() -> UIColor {
        UIColor(red: 34/255, green: 50/255, blue: 154/255, alpha: 1.0)
    }
    
    static func brandLightColor() -> Color {
        Color(uiColor: UIColor(red: 142/255, green: 155/255, blue: 240/255, alpha: 1.0))
    }
}
