//
//  UserAchievementsObject.swift
//  Cats And Dogs
//
//  Created by Levi on 4/6/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserAchievementsObject {
    var pointGoal = 0
    var missesGoal = 0
    var zeroToOneHundredGoal = 0
    var skipsGoal = 0
    var inARowGoal = 0
    var millionInMinutesGoal = 0
    var dropGoal = 0
    var minutesOfTimeGoal: Int = 0
    var noComboGoal = 0
    var hitsGoal = 0
    
    func determineNewUserAchievements(score: HighScore) -> UserAchievementsObject {
        let currentAchievementLevel = UserPrefs.currentAchievementLevel
        var currentAchievementLevelString = String()
        
        switch currentAchievementLevel {
        case 0:
           currentAchievementLevelString = "bronzeLevel"
        case 1:
            currentAchievementLevelString = "silverLevel"
        case 2:
            currentAchievementLevelString = "goldLevel"
        default:
            print("something went wrong determining the currentAchievementLevel")
        }
        
        let newUserAchievementsObject = UserAchievementsObject()
        if let pointsGoal = AchievementDataHelper.achievements["pointsGoal"]![currentAchievementLevelString] as? Int {
            if GameVariables.score >= pointsGoal {
                print("new PointsGoal Achieved")
                newUserAchievementsObject.pointGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("pointsGoal")
            }
        }
        if let missesGoal = AchievementDataHelper.achievements["missesGoal"]![currentAchievementLevelString] as? Int {
            if Int(GameVariables.missedDrops) >= missesGoal {
                print("new missedDropsGoaloal Achieved")
                newUserAchievementsObject.pointGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("missesGoal")
            }
        }
        if let zeroToOneHundredGoal = AchievementDataHelper.achievements["zeroToOneHundredGoal"]![currentAchievementLevelString] as? Int {
            // figure out how to do this - likey track the most misses on the miss meter in one variable, have a boolean switch to determine if 100 is reached again after dropping below 100 - do the math between the "most" and the 100 when 100 is reached again.  Compare the zeroToOneHundredGoal to the acheievement level value (40, 70, and 90) - have another boolean variable that goes to true when the difference exceeds the goal
        }
        if let skipsGoal = AchievementDataHelper.achievements["skipsGoal"]![currentAchievementLevelString] as? Int {
            if Int(GameVariables.skippedLevelUps) >= skipsGoal {
                print("new skipsGoal Achieved")
                newUserAchievementsObject.skipsGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("skipsGoal")
            }
        }
        if let inARowGoal = AchievementDataHelper.achievements["inARowGoal"]![currentAchievementLevelString] as? Int {
            if Int(GameVariables.longestStreak) >= inARowGoal {
                print("new inARowGoal Achieved")
                newUserAchievementsObject.inARowGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("inARowGoal")
            }
        }
        if let millionInMinutesGoal = AchievementDataHelper.achievements["millionInMinutesGoal"]![currentAchievementLevelString] as? Int {
            if Int(GameVariables.score) >= millionInMinutesGoal && GameVariables.time < 600 {
                print("new millionInMinutesGoal Achieved")
                newUserAchievementsObject.millionInMinutesGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("millionInMinutesGoal")
            }
        }
        if let dropGoal = AchievementDataHelper.achievements["dropGoal"]![currentAchievementLevelString] as? Int {
            if GameVariables.bestDrop >= dropGoal {
                print("new dropGoal Achieved")
                newUserAchievementsObject.dropGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("dropGoal")
            }
        }
        if let minutesOfTimeGoal = AchievementDataHelper.achievements["minutesOfTimeGoal"]![currentAchievementLevelString] as? Double {
            if Double(GameVariables.time) >= minutesOfTimeGoal {
                print("new minutesOfTimeGoal Achieved")
                newUserAchievementsObject.minutesOfTimeGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("minutesOfTimeGoal")
            }
        }
        if let noComboGoal = AchievementDataHelper.achievements["noComboGoal"]![currentAchievementLevelString] as? Int {
            if Int(GameVariables.score) >= noComboGoal && GameVariables.longestStreak == 0 {
                print("new noComboGoal Achieved")
                newUserAchievementsObject.noComboGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("noComboGoal")
            }
        }
        if let hitsGoal = AchievementDataHelper.achievements["hitsGoal"]![currentAchievementLevelString] as? Int {
            if Int(GameVariables.poppedDrops) >= hitsGoal {
                print("new hitsGoal Achieved")
                newUserAchievementsObject.hitsGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("hitsGoal")
            }
        }
        return newUserAchievementsObject
    }
}
