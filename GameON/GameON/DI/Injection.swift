//
//  Injection.swift
//  GameON
//
//  Created by Atharian Rahmadani on 04/10/24.
//

import Foundation
import RealmSwift
import GameON_Core
import Games
import GameDetail
import Favorite

struct APIKey {
    static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "GameON-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'GameON-Info.plist'.")
        }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'GameON-Info.plist'.")
        }
        return value
    }
}

final class Injection: NSObject {

    private func provideRealmDatabase() -> Realm? {
        let config = Realm.Configuration(
            schemaVersion: 1 // Increment the schema version if change entity
        )

        Realm.Configuration.defaultConfiguration = config

        return try? Realm()
    }

    func provideGames<U: UseCase>() -> U where U.Request == Any, U.Response == [GameDomainModel] {
        let endpoint = Endpoints.Gets.games(apiKey: APIKey.apiKey)
        let locale = GetGamesLocaleDataSource(realm: provideRealmDatabase()!)
        let remote = GetGamesRemoteDataSource(endpoint: endpoint.url, params: endpoint.parameters)
        let mapper = GameTransformer()
        let repository = GetGamesRepository(
            localeDataSource: locale,
            remoteDataSource: remote,
            mapper: mapper)

        let interactor = Interactor(repository: repository)

        guard let useCase = interactor as? U else {
            fatalError("Failed to cast Interactor to \(U.self)")
        }

        return useCase
    }

    func provideSearchGames<U: UseCase>(query: String) -> U where U.Request == Any, U.Response == [GameDomainModel] {
        let endpoint = Endpoints.Gets.searchGames(apiKey: APIKey.apiKey, query: query)
        let locale = GetGamesLocaleDataSource(realm: provideRealmDatabase()!)
        let remote = GetGamesRemoteDataSource(endpoint: endpoint.url, params: endpoint.parameters)
        let mapper = GameTransformer()
        let repository = GetGamesRepository(
            localeDataSource: locale,
            remoteDataSource: remote,
            mapper: mapper)

        let interactor = Interactor(repository: repository)

        guard let useCase = interactor as? U else {
            fatalError("Failed to cast Interactor to \(U.self)")
        }

        return useCase
    }

    func provideGameDetail<U: UseCase>(id: Int) -> U where U.Request == Any, U.Response == GameDetailDomainModel {
        let endpoint = Endpoints.Gets.details(apiKey: APIKey.apiKey, id: id)
        let locale = GetGameDetailLocaleDataSource(realm: provideRealmDatabase()!)
        let remote = GetGameDetailRemoteDataSource(endpoint: endpoint.url, params: endpoint.parameters)
        let mapper = GameDetailTransformer()
        let repository = GetGameDetailRepository(
            localeDataSource: locale,
            remoteDataSource: remote,
            mapper: mapper)

        let interactor = Interactor(repository: repository)

        guard let useCase = interactor as? U else {
            fatalError("Failed to cast Interactor to \(U.self)")
        }

        return useCase
    }

    func provideFavorites<U: UseCase>() -> U where U.Request == Any, U.Response == [FavoriteDomainModel] {
        let locale = FavoriteLocaleDataSource(realm: provideRealmDatabase()!)
        let remote = FavoriteRemoteDataSource()
        let mapper = FavoriteTransformer()
        let repository = FavoriteRepository(
            localeDataSource: locale,
            remoteDataSource: remote,
            mapper: mapper)

        let interactor = Interactor(repository: repository)

        guard let useCase = interactor as? U else {
            fatalError("Failed to cast Interactor to \(U.self)")
        }

        return useCase
    }

    func provideSetFavorite<U: UseCase>() -> U where U.Request == Any, U.Response == Bool {
        let locale = FavoriteLocaleDataSource(realm: provideRealmDatabase()!)
        let remote = FavoriteRemoteDataSource()
        let mapper = FavoriteTransformer()
        let repository = SetFavoriteRepository(
            localeDataSource: locale,
            remoteDataSource: remote,
            mapper: mapper)

        let interactor = Interactor(repository: repository)

        guard let useCase = interactor as? U else {
            fatalError("Failed to cast Interactor to \(U.self)")
        }

        return useCase
    }

}
