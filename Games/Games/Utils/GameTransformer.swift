//
//  GameTransformer.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation
import GameON_Core

public struct GameTransformer: Mapper {

    public typealias Response = GameListResponse

    public typealias Entity = [GameModuleEntity]

    public typealias Domain = [GameDomainModel]

    public init() {}

    public func transformResponseToEntity(response: GameListResponse) -> [GameModuleEntity] {
        return response.results!.map { result in
            let newGame = GameModuleEntity()

            newGame.id = result.id ?? 0
            newGame.title = result.name ?? "Unknown"
            newGame.rating = result.rating ?? 0.0
            newGame.releaseDate = result.released ?? "-"
            newGame.imageUrl = result.backgroundImage ?? ""

            return newGame
        }
    }

    public func transformEntityToDomain(entity: [GameModuleEntity]) -> [GameDomainModel] {
        return entity.map { result in
            return GameDomainModel(
                id: result.id,
                title: result.title,
                rating: result.rating,
                releaseDate: result.releaseDate,
                imageUrl: result.imageUrl
            )
        }
    }

    public func transformResponseToDomain(response: GameListResponse) -> [GameDomainModel] {
        return response.results!.map { result in
            return GameDomainModel(
                id: result.id ?? 0,
                title: result.name ?? "",
                rating: result.rating ?? 0.0,
                releaseDate: result.released ?? "",
                imageUrl: result.backgroundImage ?? ""
            )
        }
    }

    public func transformDomainToEntity(domain: [GameDomainModel]) -> [GameModuleEntity] {
        fatalError()
    }

}
