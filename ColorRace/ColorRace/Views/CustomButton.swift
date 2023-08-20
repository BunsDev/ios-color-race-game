//
//  CustomButton.swift
//  ColorRace
//
//  Created by Anup D'Souza on 20/08/23.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var titleColor: Color
    var borderColor: Color
    var shadowColor: Color
    var pressedShadowColor: Color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                backgroundColor.opacity(0.9),
                                backgroundColor
                            ]
                        ),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 2)
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.white.opacity(0.2),
                                        Color.clear
                                    ]
                                ),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .shadow(color: configuration.isPressed ? pressedShadowColor : shadowColor, radius: 5, x: 0, y: 2)
            
//            Text(configuration.label)
//                .foregroundColor(titleColor)
//                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
    }
}

struct CustomButton: View {
    var action: () -> Void
    var title: String
    var backgroundColor: Color
    var titleColor: Color
    var borderColor: Color
    var shadowColor: Color
    var pressedShadowColor: Color

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.clear)
                .buttonStyle(
                    CustomButtonStyle(
                        backgroundColor: backgroundColor,
                        titleColor: titleColor,
                        borderColor: borderColor,
                        shadowColor: shadowColor,
                        pressedShadowColor: pressedShadowColor
                    )
                )
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(
            action: {},
            title: "Custom Button",
            backgroundColor: Color.blue,
            titleColor: Color.white,
            borderColor: Color.blue,
            shadowColor: Color.gray.opacity(0.5),
            pressedShadowColor: Color.gray.opacity(0.8)
        )
        .frame(width: 200, height: 60)
    }
}
