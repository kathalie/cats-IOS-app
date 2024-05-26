//
//  CatsNetworking.swift
//  CatsNetworking
//
//  Created by Kathryn Verkhogliad on 25.05.2024.
//

import Foundation

public class CatsNetworking {
    private static func buildCatsWithBreedsUrl(limit: Int = 10, page: Int = 0) -> URL {
        let baseUrl = URL(string: "https://api.thecatapi.com/v1/images/search")!
        
        let url = baseUrl.appending(queryItems: [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "has_breeds", value: String(1))
        ])
        
        print(url)
        
        return url
    }
    
    private static func buildCatUrl(id: String) -> URL {
        let baseUrl = URL(string: "https://api.thecatapi.com/v1/images/")!
        
        let url = baseUrl.appending(path: id)
        
        print(url)
        
        return url
    }
    
    public static func getCats(limit: Int = 10, page: Int = 0) async throws -> [CatModelWithBreeds]{
        let decoder = JSONDecoder()
        
        let catsWithBreedsUrl = buildCatsWithBreedsUrl(limit: limit, page: page)
        let (data, _) = try await URLSession.shared.data(from: catsWithBreedsUrl)
        let decodedCats = try decoder.decode([CatModel].self, from: data)
        
        var cats: [CatModelWithBreeds] = [];
        
        for decodedCat in decodedCats {
            let catUrl = self.buildCatUrl(id: decodedCat.id)
            let (data, _) = try await URLSession.shared.data(from: catUrl)
            let decodedCat = try decoder.decode(CatModelWithBreeds.self, from: data)
            cats.append(decodedCat)
        }
        
        
        return cats
    }
}

