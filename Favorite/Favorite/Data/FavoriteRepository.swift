//
//  FavoriteRepository.swift
//  Favorite
//
//  Created by Atharian Rahmadani on 08/10/24.
//

import Foundation
import GameON_Core
import Combine

public struct FavoriteRepository<
    GameLocaleDataSource: LocaleDataSource,
    RemoteDataSource: DataSource,
    Transformer: Mapper
>: Repository where GameLocaleDataSource.Response == FavoriteModuleEntity,
                    RemoteDataSource.Response == Any,
                    Transformer.Response == Any,
                    Transformer.Entity == FavoriteModuleEntity,
                    Transformer.Domain == FavoriteDomainModel {

    public typealias Request = Any

    public typealias Response = [FavoriteDomainModel]

    private let _localeDataSource: GameLocaleDataSource
    private let _remoteDataSource: RemoteDataSource
    private let _mapper: Transformer

    public init(
        localeDataSource: GameLocaleDataSource,
        remoteDataSource: RemoteDataSource,
        mapper: Transformer
    ) {
        _localeDataSource = localeDataSource
        _remoteDataSource = remoteDataSource
        _mapper = mapper
    }

    public func execute(request: Request?) -> AnyPublisher<[FavoriteDomainModel], any Error> {
        return getFavoriteList()
    }

    private func getFavoriteList() -> AnyPublisher<[FavoriteDomainModel], any Error> {
        return _localeDataSource.getList(request: nil)
            .map({ entities in
                var modelArray: [FavoriteDomainModel] = []
                entities.forEach { entity in
                    let model = _mapper.transformEntityToDomain(entity: entity)
                    modelArray.append(model)
                }
                return modelArray
            })
//            .map { _mapper.transformEntityToDomain(entity: $0) }
            .eraseToAnyPublisher()
    }

}
