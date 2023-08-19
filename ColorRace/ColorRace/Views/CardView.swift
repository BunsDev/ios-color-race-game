//
//  CardView.swift
//  ColorRace
//
//  Created by Anup D'Souza on 19/08/23.
//

import SwiftUI

struct CardView: View {
    let color: Color
    let width: CGFloat = 90
    let height: CGFloat = 120
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: height)
            .border(.black, width: 2.0)
            .cornerRadius(10)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(color: .orange)
    }
}
