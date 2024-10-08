//
//  SceneDelegate.swift
//  GameON
//
//  Created by Atharian Rahmadani on 07/10/24.
//

import UIKit
import Profile

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if !UserDefaults.standard.bool(forKey: "first") {
            ProfileDummyData.addDummyData {
                UserDefaults.standard.set(true, forKey: "first")
            }
        }

        guard (scene as? UIWindowScene) != nil else { return }
    }
}
