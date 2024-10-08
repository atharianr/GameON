//
//  GetGameDetailRemoteDataSource.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation
import GameON_Core
import Combine
import Alamofire

public struct GetGameDetailRemoteDataSource: DataSource {

    public typealias Request = Any

    public typealias Response = GameDetailResponse

    private let _endpoint: String

    private let _params: [String: String]

    public init(endpoint: String, params: [String: String]) {
        _endpoint = endpoint
        _params = params
    }

    public func execute(request: Request?) -> AnyPublisher<GameDetailResponse, any Error> {
        return Future<GameDetailResponse, Error> { completion in
            if let url = URL(string: _endpoint) {
                AF.request(url, parameters: _params)
                    .validate()
                    .responseDecodable(of: GameDetailResponse.self) { response in
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
