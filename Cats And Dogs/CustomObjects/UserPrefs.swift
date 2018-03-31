//
//  UserPrefs.swift
//  Cats And Dogs
//
//  Created by Levi on 3/30/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation

class UserPrefs {
    static var loadCount: Int!
    static var musicAllowed = true
    static var rainAllowed = true
    static var soundFxAllowed = true
    
    func updateLoadCount() {
        let defaults = UserDefaults.standard
        let savedLoadCount = defaults.integer(forKey: "loadCount")
        var newLoadCount = 1
        if savedLoadCount > 0 {
            newLoadCount = savedLoadCount + 1
        }
        defaults.set(newLoadCount, forKey: "loadCount")
        UserPrefs.loadCount = newLoadCount
    }
    
    func saveUserPrefs() {
        let defaults = UserDefaults.standard
        defaults.set(UserPrefs.musicAllowed, forKey: "musicAllowed")
        defaults.set(UserPrefs.rainAllowed, forKey: "rainAllowed")
        defaults.set(UserPrefs.soundFxAllowed, forKey: "soundFxAllowed")
    }
    
    func getUserPrefs() {
        if UserPrefs.loadCount > 1 {
            let defaults = UserDefaults.standard
            UserPrefs.musicAllowed = defaults.bool(forKey: "musicAllowed")
            UserPrefs.rainAllowed = defaults.bool(forKey: "rainAllowed")
            UserPrefs.soundFxAllowed = defaults.bool(forKey: "soundFxAllowed")
        } else {
            UserPrefs.musicAllowed = true
            UserPrefs.rainAllowed = true
            UserPrefs.soundFxAllowed = true
            saveUserPrefs()
        }
    }
}
