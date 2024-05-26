//
//  CatDetailsView.swift
//  CatsUI
//
//  Created by Kathryn Verkhogliad on 25.05.2024.
//

import SwiftUI
import CatsNetworking
import WrappingHStack

struct CatDetailsView: View {
    private let cat: CatModelWithBreeds
    
    init(for cat: CatModelWithBreeds) {
        self.cat = cat
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let name = cat.breeds.first?.name {
                    Text(name)
                        .bold()
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color("MainColor"))
                }
                AsyncImage(url: URL(string: cat.url)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                } placeholder: {
                    ProgressView()
                }
                Group {
                    if let description = cat.breeds.first?.description {
                        Text(description)
                            .padding(.top, 20)
                            
                    }
                    if let temperament = cat.breeds.first?.temperament {
                        let temperaments = temperament.split(separator: ", ")
                        
                        WrappingHStack(temperaments, id:\.self) {
                            Text($0)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color("MainColor"))
                                )
                        }
                        .padding(.top, 20)
                    }
                    if let adaptability = cat.breeds.first?.adaptability {
                        CatQualityView(value: Double(adaptability), caption: "Adaptability")
                    }
                    if let catFriendly = cat.breeds.first?.cat_friendly {
                        CatQualityView(value: Double(catFriendly), caption: "Cat friendly")
                    }
                    if let dogFriendly = cat.breeds.first?.dog_friendly {
                        CatQualityView(value: Double(dogFriendly), caption: "Dog Friendly")
                    }
                    if let energyLevel = cat.breeds.first?.energy_level {
                        CatQualityView(value: Double(energyLevel), caption: "Energy Level")
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
    }
}
