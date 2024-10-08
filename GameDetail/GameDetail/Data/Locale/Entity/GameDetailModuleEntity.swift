//
//  GameDetailModuleEntity.swift
//  Game
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import Foundation
import RealmSwift

public class GameDetailModuleEntity: Object {

    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var rating: Double = 0.0
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var esrbRating: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var imageAdditionalUrl: String = ""
    @objc dynamic var publisher: String = ""
    @objc dynamic var platform: String = ""
    @objc dynamic var desc: String = ""

    public override static func primaryKey() -> String? {
        return "id"
    }
}
