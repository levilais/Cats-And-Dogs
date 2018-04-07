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
    static let achievements = [
        "pointGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to spell DOG and CAT",
            "detailDescriptionEnd": "times in a row.",
            "bronzeGoal": 7000000,
            "silverGoal": 10000000,
            "goldGoal": 25000000,
            "type": "Int64",
            "textTag": "Points"
        ],
        "missesGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to let",
            "detailDescriptionEnd": "drops hit the ground.",
            "bronzeGoal": 500,
            "silverGoal": 750,
            "goldGoal": 1500,
            "type": "Int32",
            "textTag": "Misses"
        ],
        "zeroToOneHundredGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need see your miss meter drop to",
            "detailDescriptionEnd": "and then bring it all the way back to full (100)",
            "bronzeGoal": 40,
            "silverGoal": 70,
            "goldGoal": 90,
            "type": "Int16",
            "textTag": "To 100"
        ],
        "skipsGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to let",
            "detailDescriptionEnd": "level up drops hit the ground.",
            "bronzeGoal": 10,
            "silverGoal": 15,
            "goldGoal": 30,
            "type": "Int16",
            "textTag": "Skips"
        ],
        "inARowGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to get",
            "detailDescriptionEnd": "combos in a row.",
            "bronzeGoal": 75,
            "silverGoal": 125,
            "goldGoal": 200,
            "type": "Int16",
            "textTag": "In-A-Row"
        ],
        "millionInMinutesGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to get",
            "detailDescriptionEnd": "points in 10 minutes.",
            "bronzeGoal": 5000000,
            "silverGoal": 7000000,
            "goldGoal": 10000000,
            "type": "Int64",
            "textTag": "In 10M"
        ],
        "dropGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to pop a single drop worth",
            "detailDescriptionEnd": "points.",
            "bronzeGoal": 30000,
            "silverGoal": 50000,
            "goldGoal": 75000,
            "type": "Int64",
            "textTag": "Drop"
        ],
        "minutesOfTimeGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to stay alive for",
            "detailDescriptionEnd": "minutes.",
            "bronzeGoal": 600,
            "silverGoal": 900,
            "goldGoal": 1800,
            "type": "Double",
            "textTag": "Minutes"
        ],
        "noComboGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to earn",
            "detailDescriptionEnd": "points without getting a single combo.",
            "bronzeGoal": 1000,
            "silverGoal": 5000,
            "goldGoal": 7500,
            "type": "Int32",
            "textTag": "No Combo"
        ],
        "hitsGoal": [
            "detailDescriptionBeginning": "To earn this achievement, you will need to pop",
            "detailDescriptionEnd": "drops.",
            "bronzeGoal": 1000,
            "silverGoal": 1500,
            "goldGoal": 2500,
            "type": "Int32",
            "textTag": "Hits"
        ]
    ]
}
