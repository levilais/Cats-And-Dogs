//
//  GameVariables.swift
//  Cats And Dogs
//
//  Created by Levi on 2/26/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

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
}

class GameVariables {
    static var streak: String = ""
    static var streakCount: Int = 0
    static var multiplier: Int = 1
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
        GameVariables.comboPoints = GameVariables.singleLetterPoints * 5
    }
    
    func updateMissedLevelDrop(drop: Drop) -> Drop {
        drop.missPoints = GameVariables.levelMissPoints
        if GameVariables.levelMissPoints != -90 {
            GameVariables.levelMissPoints -= 10
        }
        return drop
    }
    
    func resetGameVariables() {
        GameVariables.dropSpeed = GameControls.dropSpeed
        GameVariables.dropFrequency = GameControls.dropFrequency
        GameVariables.levelSpeed = GameControls.levelSpeed
        GameVariables.currentLevel = GameControls.currentLevel
        GameVariables.singleLetterPoints = GameControls.baseSingleLetterPoints
        GameVariables.comboPoints = GameControls.baseComboPoints
        GameVariables.multiplier = 1
        GameVariables.levelMissPoints = GameControls.baseLevelMissPoints
    }
}

class HighScores {
    static var highScores = [HighScore]()
}
