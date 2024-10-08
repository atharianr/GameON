//
//  FavoriteRemoteDataSource.swift
//  Favorite
//
//  Created by Atharian Rahmadani on 08/10/24.
//

import Foundation
import GameON_Core
import Combine

public struct FavoriteRemoteDataSource : DataSource {
    
    public typealias Request = Any
    
    public typealias Response = Any
    
    public init() {}
    
    public func execute(request: Request?) -> AnyPublisher<Any, any Error> {
        fatalError()
    }
    
}

