//
//  GetGamesRepository.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation
import GameON_Core
import Combine

public struct GetGamesRepository<
    GameLocaleDataSource: LocaleDataSource,
    RemoteDataSource: DataSource,
    Transformer: Mapper
>: Repository where GameLocaleDataSource.Response == GameModuleEntity,
                    RemoteDataSource.Response == GameListResponse,
                    Transformer.Response == GameListResponse,
                    Transformer.Entity == [GameModuleEntity],
                    Transformer.Domain == [GameDomainModel]
{
    
    public typealias Request = Any
    
    public typealias Response = [GameDomainModel]
    
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
    
    public func execute(request: Request?) -> AnyPublisher<[GameDomainModel], any Error> {
        let queryRequest = (request as? String) ?? ""
        if queryRequest.isEmpty {
            return getGameList()
        } else {
            return getSearchGameList(query: queryRequest)
        }
    }
    
    private func getGameList() -> AnyPublisher<[GameDomainModel], any Error> {
        return _localeDataSource.getList(request: nil)
            .flatMap { result -> AnyPublisher<[GameDomainModel], Error> in
                if result.isEmpty {
                    return _remoteDataSource.execute(request: nil)
                        .map { _mapper.transformResponseToEntity(response: $0) }
                        .catch { _ in _localeDataSource.getList(request: nil) }
                        .flatMap { _localeDataSource.addList(entities: $0) }
                        .filter { $0 }
                        .flatMap { _ in _localeDataSource.getList(request: nil)
                                .map { _mapper.transformEntityToDomain(entity: $0) }
                        }
                        .eraseToAnyPublisher()
                } else {
                    return _localeDataSource.getList(request: nil)
                        .map { _mapper.transformEntityToDomain(entity: $0) }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    private func getSearchGameList(query: String) -> AnyPublisher<[GameDomainModel], any Error> {
        return _remoteDataSource.execute(request: nil)
            .map { _mapper.transformResponseToDomain(response: $0) }
            .eraseToAnyPublisher()
    }
    
}
