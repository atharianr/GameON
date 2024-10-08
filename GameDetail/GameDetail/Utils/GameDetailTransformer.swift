//
//  GameDetailTransformer.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation
import GameON_Core

public struct GameDetailTransformer: Mapper {

    public typealias Response = GameDetailResponse

    public typealias Entity = GameDetailModuleEntity?

    public typealias Domain = GameDetailDomainModel

    public init() {}

    public func transformResponseToEntity(response: GameDetailResponse) -> GameDetailModuleEntity? {
        let newGame = GameDetailModuleEntity()
        let publisher = response.publishers?.map { $0.name ?? "" }.joined(separator: ", ") ?? "-"
        let platforms = response.platforms?.map {
            $0.platform?.name ?? ""
        }.joined(separator: ", ") ?? "-"

        newGame.id = response.id ?? 0
        newGame.title = response.name ?? "Unknown"
        newGame.rating = response.rating ?? 0.0
        newGame.releaseDate = response.released ?? "-"
        newGame.esrbRating = response.esrbRating?.name ?? "-"
        newGame.imageUrl = response.backgroundImage ??
        response.backgroundImageAdditional ?? ""
        newGame.imageAdditionalUrl = response.backgroundImageAdditional ??
        response.backgroundImage ?? ""
        newGame.publisher = publisher
        newGame.platform = platforms
        newGame.desc = response.descriptionRaw ?? "-"

        return newGame
    }

    public func transformEntityToDomain(entity: GameDetailModuleEntity?) -> GameDetailDomainModel {
        return GameDetailDomainModel(
            id: entity?.id ?? 0,
            title: entity?.title ?? "",
            rating: entity?.rating ?? 0.0,
            releaseDate: entity?.releaseDate ?? "",
            esrbRating: entity?.esrbRating ?? "",
            imageUrl: entity?.imageUrl ?? "",
            imageAdditionalUrl: entity?.imageAdditionalUrl ?? "",
            publisher: entity?.publisher ?? "",
            platform: entity?.platform ?? "",
            description: entity?.desc ?? ""
        )
    }

    public func transformResponseToDomain(response: GameDetailResponse) -> GameDetailDomainModel {
        let publisher = response.publishers?.map { $0.name ?? "" }.joined(separator: ", ") ?? "-"
        let platforms = response.platforms?.map {
            $0.platform?.name ?? ""
        }.joined(separator: ", ") ?? "-"

        return GameDetailDomainModel(
            id: response.id ?? 0,
            title: response.name ?? "Unknown",
            rating: response.rating ?? 0.0,
            releaseDate: response.released ?? "-",
            esrbRating: response.esrbRating?.name ?? "-",
            imageUrl: response.backgroundImage ??
            response.backgroundImageAdditional ?? "",
            imageAdditionalUrl: response.backgroundImageAdditional ??
            response.backgroundImage ?? "",
            publisher: publisher,
            platform: platforms,
            description: response.descriptionRaw ?? "-"
        )
    }

    public func transformDomainToEntity(domain: GameDetailDomainModel) -> GameDetailModuleEntity? {
        fatalError()
    }

}
