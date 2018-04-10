//
//  AchievementDataHelper.swift
//  Cats And Dogs
//
//  Created by Levi on 4/6/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import UIKit

class AchievementDataHelper {
    
    enum AchievementTag: Int {
        case pointGoal = 0
        case missesGoal = 1
        case zeroToOneHundredGoal = 2
        case skipsGoal = 3
        case inARowGoal = 4
        case millionInMinutesGoal = 5
        case dropGoal = 6
        case minutesOfTimeGoal = 7
        case noComboGoal = 8
        case hitsGoal = 9
    }
    
//    // TEST DATA
//    static let achievements = [
//        "pointGoal": [
//            "detailDescriptionBeginning": "To earn this achievement, you will need to score",
//            "detailDescriptionEnd": "points.",
//            "bronzeGoal": 100.0,
//            "silverGoal": 10000000.0,
//            "goldGoal": 25000000.0,
//            "textTag": "Points"
//        ],
//        "missesGoal": [
//            "detailDescriptionBeginning": "To earn this achievement, you will need to let",
//            "detailDescriptionEnd": "drops hit the ground.",
//            "bronzeGoal": 1.0,
//            "silverGoal": 750.0,
//            "goldGoal": 1500.0,
//            "textTag": "Misses"
//        ],
//        "zeroToOneHundredGoal": [
//            "detailDescriptionBeginning": "To earn this achievement, you will need see your miss meter drop to",
//            "detailDescriptionEnd": "and then bring it all the way back to full (100)",
//            "bronzeGoal": 99.0,
//            "silverGoal": 30.0,
//            "goldGoal": 10.0,
//            "textTag": "To 100"
//        ],
//        "skipsGoal": [
//            "detailDescriptionBeginning": "To earn this achievement, you will need to let",
//            "detailDescriptionEnd": "level up drops hit the ground.",
//            "bronzeGoal": 10.0,
//            "silverGoal": 15.0,
//            "goldGoal": 30.0,
//            "textTag": "Skips"
//        ],
//        "inARowGoal": [
//            "detailDescriptionBeginning": "To earn this achievement, you will need to get",
//            "detailDescriptionEnd": "combos in a row.",
//            "bronzeGoal": 1.0,
//            "silverGoal": 125.0,
//            "goldGoal": 200.0,
//            "textTag": "In-A-Row"
//        ],
//        "millionInMinutesGoal": [
//            "detailDescriptionBeginning": "To earn this achievement, you will need to get",
//            "detailDescriptionEnd": "points in 10 minutes.",
//            "bronzeGoal": 1.0,
//            "silverGoal": 7000000.0,
//            "goldGoal": 10000000.0,
//            "textTag": "In 10M"
//        ],
//        "dropGoal": [
//            "detailDescriptionBeginning": "To earn this achievement, you will need to pop a single drop worth",
//            "detailDescriptionEnd": "points.",
//            "bronzeGoal": 30000.0,
//            "silverGoal": 50000.0,
//            "goldGoal": 75000.0,
//            "textTag": "Drop"
//        ],
//        "minutesOfTimeGoal": [
//            "detailDescriptionBeginning": "To earn this achievement, you will need to stay alive for",
//            "detailDescriptionEnd": "minutes.",
//            "bronzeGoal": 5.0,
//            "silverGoal": 900.0,
//            "goldGoal": 1800.0,
//            "textTag": "Minutes"
//        ],
//        "noComboGoal": [
//            "detailDescriptionBeginning": "To earn this achievement, you will need to earn",
//            "detailDescriptionEnd": "points without getting a single combo.",
//            "bronzeGoal": 1000.0,
//            "silverGoal": 5000.0,
//            "goldGoal": 7500.0,
//            "textTag": "No Combo"
//        ],
//        "hitsGoal": [
//            "detailDescriptionBeginning": "To earn this achievement, you will need to pop",
//            "detailDescriptionEnd": "drops.",
//            "bronzeGoal": 1.0,
//            "silverGoal": 1500.0,
//            "goldGoal": 2500.0,
//            "textTag": "Hits"
//        ]
//    ]


    // REAL DATA
    static let achievements = [
        "pointGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to score",
            "detailDescriptionEnd": "points.",
            "bronzeGoal": 7000000.0,
            "silverGoal": 10000000.0,
            "goldGoal": 25000000.0,
            "textTag": "Points"
        ],
        "missesGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to let",
            "detailDescriptionEnd": "drops hit the ground.",
            "bronzeGoal": 500.0,
            "silverGoal": 750.0,
            "goldGoal": 1500.0,
            "textTag": "Misses"
        ],
        "zeroToOneHundredGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need see your miss meter drop to",
            "detailDescriptionEnd": "and then bring it all the way back to full (100)",
            "bronzeGoal": 60.0,
            "silverGoal": 30.0,
            "goldGoal": 10.0,
            "textTag": "To 100"
        ],
        "skipsGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to let",
            "detailDescriptionEnd": "level up drops hit the ground.",
            "bronzeGoal": 10.0,
            "silverGoal": 15.0,
            "goldGoal": 30.0,
            "textTag": "Skips"
        ],
        "inARowGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to get",
            "detailDescriptionEnd": "combos in a row.",
            "bronzeGoal": 75.0,
            "silverGoal": 125.0,
            "goldGoal": 200.0,
            "textTag": "In-A-Row"
        ],
        "millionInMinutesGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to get",
            "detailDescriptionEnd": "points in 10 minutes.",
            "bronzeGoal": 5000000.0,
            "silverGoal": 7000000.0,
            "goldGoal": 10000000.0,
            "textTag": "In 10M"
        ],
        "dropGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to pop a single drop worth",
            "detailDescriptionEnd": "points.",
            "bronzeGoal": 30000.0,
            "silverGoal": 50000.0,
            "goldGoal": 75000.0,
            "textTag": "Drop"
        ],
        "minutesOfTimeGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to stay alive for",
            "detailDescriptionEnd": "minutes.",
            "bronzeGoal": 600.0,
            "silverGoal": 900.0,
            "goldGoal": 1800.0,
            "textTag": "Minutes"
        ],
        "noComboGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to earn",
            "detailDescriptionEnd": "points without getting a single combo.",
            "bronzeGoal": 1000.0,
            "silverGoal": 5000.0,
            "goldGoal": 7500.0,
            "textTag": "No Combo"
        ],
        "hitsGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to pop",
            "detailDescriptionEnd": "drops.",
            "bronzeGoal": 1000.0,
            "silverGoal": 1500.0,
            "goldGoal": 2500.0,
            "textTag": "Hits"
        ]
    ]
}
