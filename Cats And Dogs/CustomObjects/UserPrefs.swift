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
    static var tutorialHasBeenShown = false
    static var finalCongratsHasBeenShown = false
    
    static var currentAchievementLevel = 0
    static var achievementLevelUpTriggered = false
    
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
    
    func updateCurrentAchievementLevel() {
        if UserPrefs.currentAchievementLevel < 2 {
            let defaults = UserDefaults.standard
            let newLevel = UserPrefs.currentAchievementLevel + 1
            UserPrefs.currentAchievementLevel = newLevel
            GameVariables.achievementLevelUpTriggered = true
            defaults.set(newLevel, forKey: "currentAchievementLevel")
        } else {
            print("Earned every achievement!")
        }
    }
    
    func saveTutorialAsShown() {
        UserPrefs.tutorialHasBeenShown = true
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "tutorialHasBeenShown")
    }
    
    func getUserPrefs() {
        if UserPrefs.loadCount > 1 {
            let defaults = UserDefaults.standard
            UserPrefs.musicAllowed = defaults.bool(forKey: "musicAllowed")
            UserPrefs.rainAllowed = defaults.bool(forKey: "rainAllowed")
            UserPrefs.soundFxAllowed = defaults.bool(forKey: "soundFxAllowed")
            UserPrefs.currentAchievementLevel = defaults.integer(forKey: "currentAchievementLevel")
            UserPrefs.tutorialHasBeenShown = defaults.bool(forKey: "tutorialHasBeenShown")
            UserPrefs.finalCongratsHasBeenShown = defaults.bool(forKey: "finalCongratsHasBeenShown")
        } else {
            UserPrefs.musicAllowed = true
            UserPrefs.rainAllowed = true
            UserPrefs.soundFxAllowed = true
            UserPrefs.tutorialHasBeenShown = false
            UserPrefs.finalCongratsHasBeenShown = false
            saveUserPrefs()
        }
    }
}
