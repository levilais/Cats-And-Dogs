//
//  GameVariables.swift
//  Cats And Dogs
//
//  Created by Levi on 2/26/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation

class GameControls {
    // Keep a 60 to 1 ratio for drop speed and frequency
    static var dropSpeed: TimeInterval = 20
    static var dropFrequency: TimeInterval = 0.33
    
    // Increase these when increasing drop frequency and storm
    static var baseSingleLetterPoints: Int = 100
    static var baseComboPoints: Int = 200
    static var baseMissPoints: Int = 1
    static var baseMissMeterBonus: Int = 5
    static var missMeterLimit: Int = 100
}

class GameVariables {
    static var streak: String = ""
    static var streakCount: Int = 0
    static var multiplier: Int = 1
    static var score: Int = 0
    static var missesLeft: Int = 100
    static var firstDrop: Bool = true
}
