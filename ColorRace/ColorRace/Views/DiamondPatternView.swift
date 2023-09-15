//
//  DiamondPatternView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 12/09/23.
//

import SwiftUI

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        let size = min(rect.width, rect.height)
        let xOffset = (rect.width > rect.height) ? (rect.width - rect.height) / 2.0 : 0.0
        let yOffset = (rect.height > rect.width) ? (rect.height - rect.width) / 2.0 : 0.0

        func offsetPoint(p: CGPoint) -> CGPoint {
            return CGPoint(x: p.x + xOffset, y: p.y + yOffset)
        }

        let path = Path { path in
            path.move(to: offsetPoint(p: CGPoint(x: 0, y: (size * 0.50))))
            path.addQuadCurve(to: offsetPoint(p: CGPoint(x: (size * 0.50), y: 0)),
                              control: offsetPoint(p: CGPoint(x: (size * 0.40), y: (size * 0.40))))
            path.addQuadCurve(to: offsetPoint(p: CGPoint(x: size, y: (size * 0.50))),
                              control: offsetPoint(p: CGPoint(x: (size * 0.60), y: (size * 0.40))))
            path.addQuadCurve(to: offsetPoint(p: CGPoint(x: (size * 0.50), y: size)),
                              control: offsetPoint(p: CGPoint(x: (size * 0.60), y: (size * 0.60))))
            path.addQuadCurve(to: offsetPoint(p: CGPoint(x: 0, y: (size * 0.50))),
                              control: offsetPoint(p: CGPoint(x: (size * 0.40), y: (size * 0.60))))
            path.closeSubpath()
        }
        return path
    }
}

struct DiamondPatternView: View {
    let rows :Int
    let cols: Int
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width / CGFloat(cols)
            let height = geometry.size.height / CGFloat(rows)
            VStack(spacing:0) {
                ForEach(0..<rows, id: \.self) { i in
                    let rowCols = (i%2 == 0) ? cols : cols - 1
                    HStack(spacing:0) {
                        Group {
                            ForEach(0..<rowCols, id: \.self) { _ in
                                DiamondShape()
                                    .fill(color)
                                    .frame(width: width, height: height)
                            }
                        }
                    }
                }
            }
        }
    }
}
