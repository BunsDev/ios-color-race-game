//
//  ContentView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 16/08/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            GameModeSelectionView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
