//
//  GameVariables.swift
//  Cats And Dogs
//
//  Created by Levi on 2/26/18.
//  Copyright © 2018 App Volks. All rights reserved.
//



// figure out how to do this - likey track the most misses on the miss meter in one variable, have a boolean switch to determine if 100 is reached again after dropping below 100 - do the math between the "most" and the 100 when 100 is reached again.  Compare the zeroToOneHundredGoal to the acheievement level value (40, 70, and 90) - have another boolean variable that goes to true when the difference exceeds the goal



import Foundation
import SpriteKit

class GameControls {
    // Keep a 30 to 1 ratio for drop speed and frequency
    static var initialDropDuration: TimeInterval = 20
    static var dropSpeed: CGFloat = 1
    static var dropFrequency: TimeInterval = 0.667
    static var levelUpFrequency: Double = 30
    static var levelSpeed: Double = 1
    static var currentLevel: Int = 1
    
    // Increase these when increasing drop frequency and storm
    static var baseLevelMissPoints: Int = -10
    static var baseSingleLetterPoints: Int = 100
    static var baseComboPoints: Int = 200
    static var baseMissPoints: Int = 1
    static var baseMissMeterBonus: Int = 5
    static var missMeterLimit: Int = 100
    
    // Atmosphere Controls
    static var rainFrequency: Double = 0.05
    static var rainSpeed: TimeInterval = 1.5
    
    // zeroToOneHundredGoal
    static var mostMissesTracker: Double = 100
    static var waitingForOneHundred = false
    static var mostMissesWithOneHundredHit: Double = 100
}



class GameVariables {
    static var mostMissesTracker: Double = 100
    static var waitingForOneHundred = false
    static var mostMissesWithOneHundredHit: Double = 100
    
    func determineZeroToOneHundred() {
        if Double(GameVariables.missesLeft) < GameVariables.mostMissesTracker {
            GameVariables.mostMissesTracker = Double(GameVariables.missesLeft)
            GameVariables.waitingForOneHundred = true
        }
        if GameVariables.missesLeft == 100 {
            if GameVariables.waitingForOneHundred == true {
                if GameVariables.mostMissesTracker < GameVariables.mostMissesWithOneHundredHit {
                    GameVariables.mostMissesWithOneHundredHit = GameVariables.mostMissesTracker
                }
                GameVariables.mostMissesTracker = GameControls.mostMissesTracker
                GameVariables.waitingForOneHundred = GameControls.waitingForOneHundred
            }
        }
    }
    
    static var newAchievementsToDisplay = [NewUserAchievementNotificationObject]()
    static var achievementLevelUpTriggered = false
    
    static var gameOverHighScore: HighScore?
    static var streak: String = ""
    static var streakCount: Int = 0
    static var multiplier: Int = 1 {
        didSet {
            if multiplier > GameVariables.longestStreak {
                GameVariables.longestStreak = GameVariables.multiplier
            }
        }
    }
    static var score: Int = 0
    static var missesLeft: Int = 100
    static var firstDrop: Bool = true
    static var gameIsActive: Bool = false
    static var lastNameUsed = "Tap Here To Sign" {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lastNameUsedChanged"), object: nil)
        }
    }
    static var dropSpeed: CGFloat = GameControls.dropSpeed
    static var dropFrequency: TimeInterval = GameControls.dropFrequency
    static var levelUpFrequency: Double = GameControls.levelUpFrequency
    static var levelSpeed: Double = GameControls.levelSpeed
    static var currentLevel: Int = GameControls.currentLevel
    static var singleLetterPoints = GameControls.baseSingleLetterPoints
    static var comboPoints = GameControls.baseComboPoints
    static var levelMissPoints: Int = GameControls.baseLevelMissPoints
    static var skippedLevelUps: Int = 0
    static var longestStreak: Int = 0
    static var bestDrop: Int = 0
    static var poppedDrops: Double = 0 {
        didSet {
            let totalDrops = GameVariables.poppedDrops + GameVariables.missedDrops
            GameVariables.accuracy = GameVariables.poppedDrops / totalDrops
        }
    }
    static var missedDrops: Double = 0 {
        didSet {
            let totalDrops = GameVariables.poppedDrops + GameVariables.missedDrops
            GameVariables.accuracy = (GameVariables.poppedDrops / totalDrops)
        }
    }
    static var accuracy: Double = 0
    static var time: TimeInterval = 0
    static var combos: Int = 0
    
    func levelUp(scene: SKScene) {
        GameVariables.dropSpeed = GameVariables.dropSpeed * 1.1
        GameVariables.dropFrequency = GameVariables.dropFrequency / 1.1
        for child in scene.children {
            if let drop = child as? Drop {
                drop.speed = GameVariables.dropSpeed
            }
        }
        GameVariables.levelMissPoints = -10
        GameVariables.currentLevel = GameVariables.currentLevel + 1
        GameVariables.singleLetterPoints += 100
        GameVariables.comboPoints = GameVariables.singleLetterPoints * 2
        GameAudio().setThunderVolume()
    }
    
    func updateMissedLevelDrop(drop: Drop) -> Drop {
        drop.missPoints = GameVariables.levelMissPoints
        if GameVariables.levelMissPoints != -90 {
            GameVariables.levelMissPoints -= 10
        }
        return drop
    }
    
    func accuracyString() -> String {
        let accuracyPercent = (GameVariables.accuracy.rounded(toPlaces: 2))
        let accuracyInt = Int(100 * accuracyPercent)
        return "\(accuracyInt)%"
    }
    
    func resetGameVariables() {
        GameVariables.achievementLevelUpTriggered = false
        GameVariables.newAchievementsToDisplay = []
        GameVariables.dropSpeed = GameControls.dropSpeed
        GameVariables.dropFrequency = GameControls.dropFrequency
        GameVariables.levelSpeed = GameControls.levelSpeed
        GameVariables.currentLevel = GameControls.currentLevel
        GameVariables.singleLetterPoints = GameControls.baseSingleLetterPoints
        GameVariables.comboPoints = GameControls.baseComboPoints
        GameVariables.multiplier = 1
        GameVariables.levelMissPoints = GameControls.baseLevelMissPoints
        GameVariables.skippedLevelUps = 0
        GameVariables.longestStreak = 0
        GameVariables.bestDrop = 0
        GameVariables.poppedDrops = 0
        GameVariables.missedDrops = 0
        GameVariables.time = 0
        GameVariables.accuracy = 0
        GameVariables.combos = 0
        GameAudio.thunderAudioPlayer?.setVolume(0.4, fadeDuration: 1.0)
        GameVariables.mostMissesTracker = GameControls.mostMissesTracker
        GameVariables.mostMissesWithOneHundredHit = GameControls.mostMissesWithOneHundredHit
        GameVariables.waitingForOneHundred = GameControls.waitingForOneHundred
    }
}

class HighScoresClass {
    static var highScores = [HighScore]()
}
