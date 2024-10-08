//
//  FavoriteDomainModel.swift
//  Favorite
//
//  Created by Atharian Rahmadani on 08/10/24.
//

import Foundation

public struct FavoriteDomainModel {
    public var id: Int
    public var title: String
    public var rating: Double
    public var releaseDate: String
    public var imageUrl: String
    
    public init(id: Int, title: String, rating: Double, releaseDate: String, imageUrl: String) {
        self.id = id
        self.title = title
        self.rating = rating
        self.releaseDate = releaseDate
        self.imageUrl = imageUrl
    }
}
