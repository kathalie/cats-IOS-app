//
//  CatsNetworking.swift
//  CatsNetworking
//
//  Created by Kathryn Verkhogliad on 25.05.2024.
//

import Foundation
import FirebaseCrashlytics
import FirebasePerformance

public class CatsNetworking {
    private static func buildCatsWithBreedsUrl(limit: Int = 10, page: Int = 0) -> URL {
        let baseUrl = URL(string: "https://api.thecatapi.com/v1/images/search")!
        
        let url = baseUrl.appending(queryItems: [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "has_breeds", value: String(1))
        ])
        
        return url
    }
    
    private static func buildCatUrl(id: String) -> URL {
        let baseUrl = URL(string: "https://api.thecatapi.com/v1/images/")!
        
        let url = baseUrl.appending(path: id)
        
        return url
    }
    
    private static func getCats(limit: Int = 10, page: Int = 0) async throws -> [CatModel]{
        let catsWithBreedsUrl = buildCatsWithBreedsUrl(limit: limit, page: page)
        
        Crashlytics.crashlytics().setCustomValue(catsWithBreedsUrl, forKey: "last_fetched_url")
        Crashlytics.crashlytics().log("Fetching cats by URL: \(catsWithBreedsUrl)")
        
//        guard let metric = HTTPMetric(url: catsWithBreedsUrl, httpMethod: .get) else {
//            print("Failed to initialize HTTPMetric")
//            
//            return []
//        }
//        metric.start()
        
        let (data, response) = try await URLSession.shared.data(from: catsWithBreedsUrl)
        
//        if let httpResponse = response as? HTTPURLResponse {
//            metric.responseCode = httpResponse.statusCode
//        }
//        metric.stop()
        
        let cats = try JSONDecoder().decode([CatModel].self, from: data)
        
        Crashlytics.crashlytics().log("Cats are loaded and decoded.")
        
        return cats
    }
    
    private static func getCatWithBreeds(for cat: CatModel) async throws -> CatModelWithBreeds? {
        let catUrl = self.buildCatUrl(id: cat.id)
        
        Crashlytics.crashlytics().setCustomValue(catUrl, forKey: "last_fetched_url")
        Crashlytics.crashlytics().log("Fetching a cat with breeds by URL: \(catUrl)")
        
//        guard let metric = HTTPMetric(url: catUrl, httpMethod: .get) else {
//            print("Failed to initialize HTTPMetric")
//            
//            return nil
//        }
//        metric.start()
        
        let (data, response) = try await URLSession.shared.data(from: catUrl)
        
//        if let httpResponse = response as? HTTPURLResponse {
//            metric.responseCode = httpResponse.statusCode
//        }
//        metric.stop()
        
        let decodedCat = try JSONDecoder().decode(CatModelWithBreeds.self, from: data)
        
        Crashlytics.crashlytics().log("Cat with breeds is loaded and decoded.")
        
        return decodedCat
    }
    
    
    
    public static func getCatsWithBreeds(limit: Int = 10, page: Int = 0) async throws -> [CatModelWithBreeds]{
        let cats = try await getCats(limit: limit, page: page)
        
        var catsWithBreeds: [CatModelWithBreeds] = [];
        
        for cat in cats {
            if let catWithBreeds = try await getCatWithBreeds(for: cat) {
                catsWithBreeds.append(catWithBreeds)
            }
        }
        
        return catsWithBreeds
    }
}

