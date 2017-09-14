//
//  UsernameController.swift
//  DropMusic
//
//  Created by Angel Contreras on 9/13/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import Foundation

final class UsernameController{
    
    private let key = "MusicDropUsernameKey"
    private let userDefaults = UserDefaults(suiteName: "MusicDrop")
    
    static let shared = UsernameController()
    
    private var username: String? {
        set {
            if let newUsername = newValue {
                userDefaults?.set(newUsername, forKey: key)
            }
        }
        get {
            return userDefaults?.string(forKey: key)
        }
    }
    
    func set(username: String, success: @escaping (Bool) -> ()) {
        self.username = username
        if let setUserName = self.username {
            if setUserName == username {
                success(true)
            } else {
                success(false)
            }
        }
    }
    
    func getUserName() -> String? {
        return self.username
    }
}
