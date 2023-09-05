//
//  StartView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 20/08/23.
//

import SwiftUI

struct StartView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(GameStrings.title)
                    .font(GameUx.titleFont())
                    .padding()
                NavigationLink(destination: GameView()) {
                    textView(GameStrings.enter)
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder private func textView(_ title: String) -> some View {
        Text(title)
            .font(GameUx.buttonFont())
            .foregroundColor(.black)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
