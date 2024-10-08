//
//  GameListResponse.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation

// MARK: - GameListResponse
public struct GameListResponse: Codable {
    let results: [Result]?
}

// MARK: - Result
public struct Result: Codable {
    let id: Int?
    let name, released: String?
    let backgroundImage: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
    }
}

// MARK: - EsrbRating
public struct EsrbRating: Codable {
    let id: Int?
    let name, slug: String?
}

// MARK: - PlatformElement
public struct PlatformElement: Codable {
    let platform: PlatformPlatform?
}

// MARK: - PlatformPlatform
public struct PlatformPlatform: Codable {
    let name: String?
}
