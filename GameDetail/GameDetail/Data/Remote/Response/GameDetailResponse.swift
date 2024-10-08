//
//  GameDetailResponse.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation

// MARK: - GameDetailResponse
public struct GameDetailResponse: Codable {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage, backgroundImageAdditional: String?
    let rating: Double?
    let platforms: [PlatformElement]?
    let publishers: [Developer]?
    let esrbRating: EsrbRating?
    let descriptionRaw: String?

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case rating, platforms, publishers
        case esrbRating = "esrb_rating"
        case descriptionRaw = "description_raw"
    }
}

// MARK: - Developer
public struct Developer: Codable {
    let name: String?
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
