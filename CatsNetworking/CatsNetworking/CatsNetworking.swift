//
//  CatsNetworking.swift
//  CatsNetworking
//
//  Created by Kathryn Verkhogliad on 25.05.2024.
//

import Foundation
import FirebaseCrashlytics
import FirebasePerformance

public enum Api: String {
    case cats = "https://api.thecatapi.com"
    case dogs = "https://api.thedogapi.com"
}

public class Networking {
    private let api: Api
    
    public init(api: Api) {
        self.api = api
    }
    
    private func buildGetManyWithBreedsUrl(limit: Int = 10, page: Int = 0) -> URL {
        let baseUrl = URL(string: "\(self.api.rawValue)/v1/images/search")!
        
        let url = baseUrl.appending(queryItems: [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "has_breeds", value: String(1))
        ])
        
        return url
    }
    
    private func buildGetOneUrl(id: String) -> URL {
        let baseUrl = URL(string: "\(self.api.rawValue)/v1/images/")!
        
        let url = baseUrl.appending(path: id)
        
        return url
    }
    
    private func getMany(limit: Int = 10, page: Int = 0) async throws -> [CatModel]{
        let catsWithBreedsUrl = buildGetManyWithBreedsUrl(limit: limit, page: page)
        
        let fetch = { () in return try await URLSession.shared.data(from: catsWithBreedsUrl)}
        let decode = { (_ data: Data ) in return try JSONDecoder().decode([CatModel].self, from: data) }
        
        Crashlytics.crashlytics().setCustomValue(catsWithBreedsUrl, forKey: "last_fetched_url")
        Crashlytics.crashlytics().log("Fetching cats by URL: \(catsWithBreedsUrl)")
        
        guard let metric = HTTPMetric(url: catsWithBreedsUrl, httpMethod: .get) else {
            print("Failed to initialize HTTPMetric")
            
            let (data, _) = try await fetch()
            let cats = try decode(data)
            
            return cats
        }
        metric.start()
        
        let (data, response) = try await fetch()
        
        if let httpResponse = response as? HTTPURLResponse {
            metric.responseCode = httpResponse.statusCode
        }
        metric.stop()
        
        let cats = try decode(data)
        
        Crashlytics.crashlytics().log("Cats are loaded and decoded.")
        
        return cats
    }
    
    private func getOne(for cat: CatModel) async throws -> CatModelWithBreeds? {
        let catUrl = self.buildGetOneUrl(id: cat.id)
        
        let fetch = { () in return try await URLSession.shared.data(from: catUrl)}
        let decode = { (_ data: Data ) in return try JSONDecoder().decode(CatModelWithBreeds.self, from: data) }
        
        Crashlytics.crashlytics().setCustomValue(catUrl, forKey: "last_fetched_url")
        Crashlytics.crashlytics().log("Fetching a cat with breeds by URL: \(catUrl)")
        
        guard let metric = HTTPMetric(url: catUrl, httpMethod: .get) else {
            print("Failed to initialize HTTPMetric")
            
            let (data, _) = try await fetch()
            let cat = try decode(data)
            
            return cat
        }
        metric.start()
        
        let (data, response) = try await fetch()
        
        if let httpResponse = response as? HTTPURLResponse {
            metric.responseCode = httpResponse.statusCode
        }
        metric.stop()
        
        let cat = try decode(data)
        
        Crashlytics.crashlytics().log("Cat with breeds is loaded and decoded.")
        
        return cat
    }
    
    public func getManyWithBreeds(limit: Int = 10, page: Int = 0) async throws -> [CatModelWithBreeds]{
        let cats = try await getMany(limit: limit, page: page)
        
        var catsWithBreeds: [CatModelWithBreeds] = [];
        
        for cat in cats {
            if let catWithBreeds = try await getOne(for: cat) {
                catsWithBreeds.append(catWithBreeds)
            }
        }
        
        return catsWithBreeds
    }
}

