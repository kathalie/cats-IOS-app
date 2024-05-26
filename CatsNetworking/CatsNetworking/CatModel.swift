//
//  ImageModel.swift
//  CatsNetworking
//
//  Created by Kathryn Verkhogliad on 24.05.2024.
//

import Foundation

public struct CatModel: Codable {
    public let id: String
    public let url: String
}

public struct CatModelWithBreeds: Codable, Hashable {
    public let id: String
    public let url: String
    public let breeds: [Breeds]
}

public struct Breeds: Codable, Hashable {
    public let name: String?
    public let origin: String?
    public let description: String?
    public let temperament: String?
    public let adaptability: Int?
    public let cat_friendly: Int?
    public let dog_friendly: Int?
    public let energy_level: Int?
}
