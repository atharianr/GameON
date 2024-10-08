//
//  File.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation
import GameON_Core
import Combine
import RealmSwift

public struct GetGamesLocaleDataSource: LocaleDataSource {

    public typealias Request = Any

    public typealias Response = GameModuleEntity

    private let _realm: Realm

    public init(realm: Realm) {
        _realm = realm
    }

    public func getList(request: Request?) -> AnyPublisher<[GameModuleEntity], any Error> {
        return Future<[GameModuleEntity], Error> { completion in
            let games: Results<GameModuleEntity> = {
                _realm.objects(GameModuleEntity.self)
            }()
            completion(.success(games.toArray(ofType: GameModuleEntity.self)))

        }.eraseToAnyPublisher()
    }

    public func addList(entities: [GameModuleEntity]) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error> { completion in
            do {
                try _realm.write {
                    for game in entities {
                        _realm.add(game, update: .all)
                    }
                    completion(.success(true))
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }

        }.eraseToAnyPublisher()
    }

    public func get(id: Int) -> AnyPublisher<GameModuleEntity, any Error> {
        fatalError()
    }

    public func add(entity: GameModuleEntity) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }

    public func update(id: Int, entity: GameModuleEntity) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }

    public func delete(id: Int) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }

    public func isExist(id: Int) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }
}
