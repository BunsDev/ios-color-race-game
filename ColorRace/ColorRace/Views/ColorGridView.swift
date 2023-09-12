//
//  ColorGridView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 22/08/23.
//

import SwiftUI
import UIKit

struct ColorGridView: View {
    let cardType: CardType
    let colors: [[UIColor]]
    let displayDefault: Bool
    
    private let spacing = 2.0
    private let shadowRadius = 50.0
    private let defaultColor: Color = .white
    private var defaultColorGradient: LinearGradient {
        LinearGradient(gradient: Gradient(
            colors: [
                Color(uiColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)),
                Color(uiColor: UIColor(red: 249/255, green: 249/255, blue: 255/255, alpha: 1.0))
            ]), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: spacing) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<3, id: \.self) { column in
                            RoundedRectangle(cornerRadius: 2, style: .continuous)
                                .fill(gradient(row: row, col: column))
                                .frame(width: (geometry.size.width - (spacing*2)) / 3, height: (geometry.size.width - (spacing*2)) / 3)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                                        .stroke(Color.black, lineWidth: 1.0)
                                }
                        }
                    }
                }
            }
//            .shadow(radius: shadowRadius)
        }
    }
    
    private func gradient(row: Int, col: Int) -> LinearGradient {
        guard displayDefault else {
            return gradientWithColors(colors[row][col])
        }
        return defaultColorGradient
    }
    
    private func gradientWithColors(_ color: UIColor) -> LinearGradient {
        if color == UIColor.blue {
            return LinearGradient(gradient: Gradient(
                colors: [
                    Color(uiColor: UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1.0)),
                    Color(uiColor: UIColor(red: 77/255, green: 85/255, blue: 240/255, alpha: 1.0))
                ]), startPoint: .top, endPoint: .bottom)
            
        } else if color == UIColor.orange {
            return LinearGradient(gradient: Gradient(
                colors: [
                    Color(uiColor: UIColor(red: 248/255, green: 196/255, blue: 119/255, alpha: 1.0)),
                    Color(uiColor: UIColor(red: 251/255, green: 161/255, blue: 26/255, alpha: 1.0))
                ]), startPoint: .top, endPoint: .bottom)
            
        } else if color == UIColor.yellow {
            return LinearGradient(gradient: Gradient(
                colors: [
                    Color(uiColor: UIColor(red: 236/255, green: 238/255, blue: 130/255, alpha: 1.0)),
                    Color(uiColor: UIColor(red: 230/255, green: 234/255, blue: 32/255, alpha: 1.0))
                ]), startPoint: .top, endPoint: .bottom)
            
        } else if color == UIColor.green {
            return LinearGradient(gradient: Gradient(
                colors: [
                    Color(uiColor: UIColor(red: 121/255, green: 223/255, blue: 156/255, alpha: 1.0)),
                    Color(uiColor: UIColor(red: 85/255, green: 170/255, blue: 104/255, alpha: 1.0))
                ]), startPoint: .top, endPoint: .bottom)
            
        } else if color == UIColor.red {
            return LinearGradient(gradient: Gradient(
                colors: [
                    Color(uiColor: UIColor(red: 221/255, green: 113/255, blue: 130/255, alpha: 1.0)),
                    Color(uiColor: UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 1.0))
                ]), startPoint: .top, endPoint: .bottom)
            
        } else {
            return defaultColorGradient
        }
    }
}

struct ColorGridView_Previews: PreviewProvider {
    static var previews: some View {
        ColorGridView(cardType: .small,
                      colors: [[.red, .red, .red],[.blue, .blue, .blue], [.orange, .orange, .orange]],
                      displayDefault: true)
    }
}
