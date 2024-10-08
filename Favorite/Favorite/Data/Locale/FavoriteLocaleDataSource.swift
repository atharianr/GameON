//
//  FavoriteLocaleDataSource.swift
//  Favorite
//
//  Created by Atharian Rahmadani on 08/10/24.
//

import Foundation
import GameON_Core
import Combine
import RealmSwift

public struct FavoriteLocaleDataSource: LocaleDataSource {

    public typealias Request = Any

    public typealias Response = FavoriteModuleEntity

    private let _realm: Realm

    public init(realm: Realm) {
        _realm = realm
    }

    public func getList(request: Request?) -> AnyPublisher<[FavoriteModuleEntity], any Error> {
        return Future<[FavoriteModuleEntity], Error> { completion in
            let games: Results<FavoriteModuleEntity> = {
                _realm.objects(FavoriteModuleEntity.self)
                    .sorted(byKeyPath: "title", ascending: true)
            }()
            completion(.success(games.toArray(ofType: FavoriteModuleEntity.self)))

        }.eraseToAnyPublisher()
    }

    public func addList(entities: [FavoriteModuleEntity]) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }

    public func get(id: Int) -> AnyPublisher<FavoriteModuleEntity, any Error> {
        fatalError()
    }

    public func add(entity: FavoriteModuleEntity) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error> { completion in
            do {
                try _realm.write {
                    _realm.add(entity, update: .all)
                    completion(.success(true))
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }.eraseToAnyPublisher()
    }

    public func update(id: Int, entity: FavoriteModuleEntity) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }

    public func delete(id: Int) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error> { completion in
            do {
                try _realm.write {
                    if let gameToDelete = _realm.object(
                        ofType: FavoriteModuleEntity.self,
                        forPrimaryKey: id
                    ) {
                        _realm.delete(gameToDelete)
                        completion(.success(true))
                    } else {
                        completion(.failure(DatabaseError.requestFailed))
                    }
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }.eraseToAnyPublisher()
    }

    public func isExist(id: Int) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error> { completion in
            do {
                try _realm.write {
                    if _realm.object(
                        ofType: FavoriteModuleEntity.self,
                        forPrimaryKey: id
                    ) != nil {
                        completion(.success(true))
                    } else {
                        completion(.success(false))
                    }
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }.eraseToAnyPublisher()
    }

}
