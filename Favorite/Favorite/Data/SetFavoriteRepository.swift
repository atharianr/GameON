//
//  SetFavoriteRepository.swift
//  Favorite
//
//  Created by Atharian Rahmadani on 08/10/24.
//

import Foundation
import GameON_Core
import Combine

public struct SetFavoriteRepository<
    GameLocaleDataSource: LocaleDataSource,
    RemoteDataSource: DataSource,
    Transformer: Mapper
>: Repository where GameLocaleDataSource.Response == FavoriteModuleEntity,
                    RemoteDataSource.Response == Any,
                    Transformer.Response == Any,
                    Transformer.Entity == FavoriteModuleEntity,
                    Transformer.Domain == FavoriteDomainModel
{
    
    public typealias Request = Any
    
    public typealias Response = Bool
    
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
    
    public func execute(request: Request?) -> AnyPublisher<Bool, any Error> {
        if let request = request as? [String: FavoriteDomainModel] {
            switch request.keys.first {
            case "add":
                return addFavorite(domain: request["add"]!)
            case "delete":
                return deleteFavorite(domain: request["delete"]!)
            default:
                return isFavoriteExist(domain: request["isExist"]!)
            }
        } else {
            fatalError()
        }
    }
    
    private func addFavorite(domain: FavoriteDomainModel) -> AnyPublisher<Bool, any Error> {
        return _localeDataSource.add(entity: _mapper.transformDomainToEntity(domain: domain))
            .eraseToAnyPublisher()
    }
    
    private func deleteFavorite(domain: FavoriteDomainModel) -> AnyPublisher<Bool, any Error> {
        return _localeDataSource.delete(id: domain.id)
            .eraseToAnyPublisher()
    }
    
    private func isFavoriteExist(domain: FavoriteDomainModel) -> AnyPublisher<Bool, any Error> {
        return _localeDataSource.isExist(id: domain.id)
            .eraseToAnyPublisher()
    }
    
}
