//
//  ProfileModel.swift
//  GameON
//
//  Created by Atharian Rahmadani on 02/10/24.
//

import Foundation

public struct ProfileModel {
    static let nameKey = "name"
    static let occupationKey = "occupation"
    static let organizationKey = "organization"
    static let imageKey = "image"

    public static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }

    public static var occupation: String {
        get {
            return UserDefaults.standard.string(forKey: occupationKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: occupationKey)
        }
    }

    public static var organization: String {
        get {
            return UserDefaults.standard.string(forKey: organizationKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: organizationKey)
        }
    }

    public static var image: Data {
        get {
            return UserDefaults.standard.data(forKey: imageKey) ?? Data()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: imageKey)
        }
    }

    public static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
