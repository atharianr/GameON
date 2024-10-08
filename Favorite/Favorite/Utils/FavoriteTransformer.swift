//
//  FavoriteTransformer.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation
import GameON_Core

public struct FavoriteTransformer: Mapper {

    public typealias Response = Any

    public typealias Entity = FavoriteModuleEntity
//    public typealias Entity = [FavoriteModuleEntity]

    public typealias Domain = FavoriteDomainModel
//    public typealias Domain = [FavoriteDomainModel]

    public init() {}

    public func transformResponseToEntity(response: Any) -> FavoriteModuleEntity {
        fatalError()
    }

    public func transformEntityToDomain(entity: FavoriteModuleEntity) -> FavoriteDomainModel {
        return FavoriteDomainModel(
            id: entity.id,
            title: entity.title,
            rating: entity.rating,
            releaseDate: entity.releaseDate,
            imageUrl: entity.imageUrl
        )
    }

    public func transformResponseToDomain(response: Any) -> FavoriteDomainModel {
        fatalError()
    }

    public func transformDomainToEntity(domain: FavoriteDomainModel) -> FavoriteModuleEntity {
        let newGame = FavoriteModuleEntity()

        newGame.id = domain.id
        newGame.title = domain.title
        newGame.rating = domain.rating
        newGame.releaseDate = domain.releaseDate
        newGame.imageUrl = domain.imageUrl

        return newGame
    }
}
