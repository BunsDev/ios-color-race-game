//
//  NewContentView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 27/08/23.
//

import SwiftUI
import UIKit

struct NewContentView: View {
    @State private var isMatching = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            VStack { // nav bar
                Color.blue
                    .frame(height: 50)
            }
            VStack { // user info bar
                HStack {
                    Color.green
                        .frame(height: 100)
                    Text("Text")
                    Color.green
                        .frame(height: 100)
                }
            }
            VStack { // game board view
                GeometryReader { geometry in
                    VStack {
                        BoardViewRepresentable(isMatching: $isMatching)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .border(.red, width: 1)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .clipped()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isMatching = true
            }
        }
    }
}

struct NewContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewContentView()
    }
}
