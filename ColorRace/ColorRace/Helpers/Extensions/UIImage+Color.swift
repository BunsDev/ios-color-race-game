//
//  UIImage+Color.swift
//  ColorRace
//
//  Created by Anup D'Souza on 05/09/23.
//

import Foundation
import UIKit

extension UIImage {
    static func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    func toHex() -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        
        let redHex = String(format: "%02lX", lroundf(red * 255))
        let greenHex = String(format: "%02lX", lroundf(green * 255))
        let blueHex = String(format: "%02lX", lroundf(blue * 255))
        
        return "#" + redHex + greenHex + blueHex
    }
}

extension UIColor {
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
