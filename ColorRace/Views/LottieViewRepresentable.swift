//
//  LottieViewRepresentable.swift
//  ColorRace
//
//  Created by Anup D'Souza on 15/09/23.
//

import Foundation
import SwiftUI
import Lottie

struct LottieViewRepresentable: UIViewRepresentable {
    let filename: String
    let loopMode: LottieLoopMode

    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: filename)
        animationView.loopMode = loopMode
        animationView.play { completed in
            print("animation completed")
        }
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {}
}
