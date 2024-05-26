//
//  CatQuality.swift
//  CatsUI
//
//  Created by Kathryn Verkhogliad on 26.05.2024.
//

import SwiftUI

struct CatQualityView: View {
    private let value: Double;
    private let caption: String
    
    init(value: Double, caption: String) {
        self.value = value
        self.caption = caption
    }
    
    var body: some View {
        VStack {
            Text(self.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            ProgressView(value: self.value / 5.0)
                .tint(Color("MainColor"))
                .scaleEffect(x: 1, y: 5, anchor: .center)
                .padding(.top, 10)
        }
        .padding(.top, 20)
    }
}
