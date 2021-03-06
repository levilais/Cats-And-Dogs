//
//  HighScoreObject.swift
//  Cats And Dogs
//
//  Created by Levi on 3/5/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation

class HighScore {
    var identifier: String!
    var score: Int!
    var playerName: String!
    var timestamp: Date!
    var time: Double!
    var level: Int = 1
    var skippedLevelUps: Int = 0
    var longestStreak: Int = 0
    var bestDrop: Int = 0
    var poppedDrops: Double = 0
    var missedDrops: Double = 0
    var accuracy: Double = 0
    var combos: Int = 0
    
    func formattedScore(score: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: score as! NSNumber) {
            return formattedNumber
        } else {
            return nil
        }
    }
}
