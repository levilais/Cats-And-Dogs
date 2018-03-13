//
//  HighScoreObject.swift
//  Cats And Dogs
//
//  Created by Levi on 3/5/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation

class HighScore {
    var score: Int!
    var playerName: String!
    var timestamp: Date!
    
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
