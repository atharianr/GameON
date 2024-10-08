//
//  GetGamesRemoteDataSource.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation
import GameON_Core
import Combine
import Alamofire

public struct GetGamesRemoteDataSource : DataSource {
    
    public typealias Request = Any
    
    public typealias Response = GameListResponse
    
    private let _endpoint: String
    
    private let _params: [String : String]
    
    public init(endpoint: String, params: [String : String]) {
        _endpoint = endpoint
        _params = params
    }
    
    public func execute(request: Request?) -> AnyPublisher<GameListResponse, any Error> {
        return Future<GameListResponse, Error> { completion in
            if let url = URL(string: _endpoint) {
                AF.request(url, parameters: _params)
                    .validate()
                    .responseDecodable(of: GameListResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
}
