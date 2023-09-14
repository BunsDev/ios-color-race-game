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
                .white,
                .white
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
                    Color(uiColor: UIColor(red: 77/255, green: 85/255, blue: 240/255, alpha: 1.0)),
                    Color(uiColor: UIColor(red: 77/255, green: 85/255, blue: 240/255, alpha: 1.0))
                ]), startPoint: .top, endPoint: .bottom)
            
        } else if color == UIColor.orange {
            return LinearGradient(gradient: Gradient(
                colors: [
                    Color(uiColor: UIColor(red: 251/255, green: 161/255, blue: 26/255, alpha: 1.0)),
                    Color(uiColor: UIColor(red: 251/255, green: 161/255, blue: 26/255, alpha: 1.0))
                ]), startPoint: .top, endPoint: .bottom)
            
        } else if color == UIColor.yellow {
            return LinearGradient(gradient: Gradient(
                colors: [
                    Color(uiColor: UIColor(red: 251/255, green: 231/255, blue: 78/255, alpha: 1.0)),
                    Color(uiColor: UIColor(red: 251/255, green: 231/255, blue: 78/255, alpha: 1.0))
                ]), startPoint: .top, endPoint: .bottom)
            
        } else if color == UIColor.green {
            return LinearGradient(gradient: Gradient(
                colors: [
                    Color(uiColor: UIColor(red: 75/255, green: 165/255, blue: 99/255, alpha: 1.0)),
                    Color(uiColor: UIColor(red: 75/255, green: 165/255, blue: 99/255, alpha: 1.0))
                ]), startPoint: .top, endPoint: .bottom)
            
        } else if color == UIColor.red {
            return LinearGradient(gradient: Gradient(
                colors: [
                    Color(uiColor: UIColor(red: 200/255, green: 62/255, blue: 58/255, alpha: 1.0)),
                    Color(uiColor: UIColor(red: 200/255, green: 62/255, blue: 58/255, alpha: 1.0))
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
