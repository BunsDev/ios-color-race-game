//
//  UIView+Tap.swift
//  ColorRace
//
//  Created by Anup D'Souza on 10/09/23.
//

import Foundation
import UIKit

extension UIView {
    func showAnimation(_ completionBlock: @escaping () -> Void) {
        guard self.transform.isIdentity else { return }
        UIView.animate(withDuration: 0.05,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  _ in
            self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            
        }
    }
}
