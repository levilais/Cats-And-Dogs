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
    static var dropSpeed: TimeInterval = 60
    static var dropFrequency: TimeInterval = 1
    
    // Increase these when increasing drop frequency and storm
    static var baseSingleLetterPoints: Int = 500
    static var baseComboPoints: Int = 1000
    static var baseMissPoints: Int = 1
    static var baseMissMeterBonus: Int = 5
    static var missMeterLimit: Int = 100
}

class GameVariables {
    static var streak: String = ""
    static var streakCount: Int = 0
    static var multiplier: Int = 1
    static var score: Int = 0
    static var missMeterValue: Int = 100
    static var firstDrop: Bool = true
}
