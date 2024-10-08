//
//  GetGameDetailLocaleDataSource.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation
import GameON_Core
import Combine
import RealmSwift

public struct GetGameDetailLocaleDataSource: LocaleDataSource {
    
    public typealias Request = Any
    
    public typealias Response = GameDetailModuleEntity?
    
    private let _realm: Realm
    
    public init(realm: Realm) {
        _realm = realm
    }
    
    public func getList(request: Request?) -> AnyPublisher<[GameDetailModuleEntity?], any Error> {
        fatalError()
    }
    
    public func addList(entities: [GameDetailModuleEntity?]) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }
    
    public func get(id: Int) -> AnyPublisher<GameDetailModuleEntity?, any Error> {
        return Future<GameDetailModuleEntity?, Error> { completion in
            let gameDetail = _realm.object(ofType: GameDetailModuleEntity.self, forPrimaryKey: id)
            completion(.success(gameDetail))
        }.eraseToAnyPublisher()
    }
    
    public func add(entity: GameDetailModuleEntity?) -> AnyPublisher<Bool, any Error> {
        return Future<Bool, Error> { completion in
            do {
                try _realm.write {
                    if let entity = entity {
                        _realm.add(entity, update: .all)
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
    
    public func update(id: Int, entity: GameDetailModuleEntity?) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }
    
    public func delete(id: Int) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }
    
    public func isExist(id: Int) -> AnyPublisher<Bool, any Error> {
        fatalError()
    }
}
