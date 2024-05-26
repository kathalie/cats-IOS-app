//
//  CatImageView.swift
//  CatsUI
//
//  Created by Kathryn Verkhogliad on 25.05.2024.
//


import SwiftUI
import CatsNetworking

struct CatTileView: View {
    private let cat: CatModelWithBreeds
    
    init(for cat: CatModelWithBreeds) {
        self.cat = cat
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: cat.url)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
                    .background(Color("MainBgColor"))
            }
            .scaledToFill()
            .frame(width: 230, height: 200)
            .clipped()
            .clipShape(
                .rect(
                    bottomTrailingRadius: 20,
                    topTrailingRadius: 20
                )
            )
            if let name = cat.breeds.first?.name {
                Text(name)
                    .font(.title3)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 16)
        .background(Color("MainBgColor"))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


//#Preview {
//    CatTileView(for: CatModelWithBreeds(
//        id: "kx92rm8",
//        url: "https://hws.dev/paul2.jpg",
//        width: 1,
//        height: 1,
//        breeds: []
//    ))
//}
