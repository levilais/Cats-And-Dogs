//
//  GameVariables.swift
//  Cats And Dogs
//
//  Created by Levi on 2/26/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation

class GameControls {
    
    static var dropSpeed: TimeInterval = 30
    static var dropFrequency: TimeInterval = 0.5
    static var baseSingleLetterPoints: Int = 500
    static var baseComboPoints: Int = 1000
}

class GameVariables {
    static var streak = ""
    static var streakCount: Int = 0
    static var multiplier: Int = 1
    static var score: Int = 0
}
