//
//  GameColors.swift
//  ColorRace
//
//  Created by Anup D'Souza on 14/09/23.
//

import Foundation
import UIKit

struct GameColors {
    
    static func blue() -> UIColor {
        UIColor(red: 77/255, green: 85/255, blue: 240/255, alpha: 1.0)
    }
    
    static func orange() -> UIColor {
        UIColor(red: 251/255, green: 161/255, blue: 26/255, alpha: 1.0)
    }
    
    static func yellow() -> UIColor {
        UIColor(red: 251/255, green: 231/255, blue: 78/255, alpha: 1.0)
    }
    
    static func green() -> UIColor {
        UIColor(red: 75/255, green: 165/255, blue: 99/255, alpha: 1.0)
    }
    
    static func red() -> UIColor {
        UIColor(red: 200/255, green: 62/255, blue: 58/255, alpha: 1.0)
    }
    
    static func white() -> UIColor {
        UIColor.white
    }
    
    static func paletteColors() -> [UIColor] {
        [
            GameColors.white(), GameColors.blue(), GameColors.orange(), GameColors.yellow(), GameColors.green(), GameColors.red()
        ]
    }
    
    static func defaultColors() -> [[UIColor]] {
        Array(repeating: Array(repeating: GameColors.white(), count: 3), count: 3)
    }
}
