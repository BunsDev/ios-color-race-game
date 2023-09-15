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
