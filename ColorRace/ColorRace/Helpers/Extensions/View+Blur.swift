//
//  View+Blur.swift
//  ColorRace
//
//  Created by Anup D'Souza on 10/09/23.
//

import Foundation
import SwiftUI

extension View {
    func backgroundBlur(radius: CGFloat = 3, opaque: Bool = false) -> some View {
        self
            .background(
                Blur(radius: radius, opaque: opaque)
            )
    }
}
