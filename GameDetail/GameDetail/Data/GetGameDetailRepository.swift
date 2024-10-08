//
//  GetGameDetailRepository.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation
import GameON_Core
import Combine

public struct GetGameDetailRepository<
    GameLocaleDataSource: LocaleDataSource,
    RemoteDataSource: DataSource,
    Transformer: Mapper
>: Repository where GameLocaleDataSource.Response == GameDetailModuleEntity?,
                    RemoteDataSource.Response == GameDetailResponse,
                    Transformer.Response == GameDetailResponse,
                    Transformer.Entity == GameDetailModuleEntity?,
                    Transformer.Domain == GameDetailDomainModel {

    public typealias Request = Any

    public typealias Response = GameDetailDomainModel

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

    public func execute(request: Request?) -> AnyPublisher<GameDetailDomainModel, any Error> {
        let idRequest = (request as? Int) ?? 0
        return getGameDetail(id: idRequest)
    }

    func getGameDetail(id: Int) -> AnyPublisher<GameDetailDomainModel, Error> {
        return _localeDataSource.get(id: id)
            .map { _mapper.transformEntityToDomain(entity: $0)}
            .flatMap { gameDetail -> AnyPublisher<GameDetailDomainModel, Error> in
                if gameDetail.id == 0 {
                    return self._remoteDataSource.execute(request: nil)
                        .map { _mapper.transformResponseToEntity(response: $0) }
                        .flatMap { self._localeDataSource.add(entity: $0) }
                        .filter { $0 }
                        .flatMap { _ in
                            self._localeDataSource.get(id: id)
                                .map { _mapper.transformEntityToDomain(entity: $0) }
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Just(gameDetail)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
