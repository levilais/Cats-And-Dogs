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
    
    func currentUserAchievementsObject() -> UserAchievementsObject {
        let currentUserAchievements = UserAchievementsObject()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAchievements")
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    print("\(results.count) achievement objects found")
                    if let managedObject = results[0] as? UserAchievements {
                        currentUserAchievements.pointGoal = Int(managedObject.pointGoal)
                        print("point Int = \(currentUserAchievements.pointGoal)")
                        currentUserAchievements.missesGoal = Int(managedObject.missesGoal)
                        currentUserAchievements.zeroToOneHundredGoal = Int(managedObject.zeroToOneHundredGoal)
                        currentUserAchievements.skipsGoal = Int(managedObject.skipsGoal)
                        currentUserAchievements.inARowGoal = Int(managedObject.inARowGoal)
                        currentUserAchievements.millionInMinutesGoal = Int(managedObject.millionInMinutesGoal)
                        currentUserAchievements.dropGoal = Int(managedObject.dropGoal)
                        currentUserAchievements.minutesOfTimeGoal = Int(managedObject.minutesOfTimeGoal)
                        currentUserAchievements.noComboGoal = Int(managedObject.noComboGoal)
                        currentUserAchievements.hitsGoal = Int(managedObject.hitsGoal)
                    }
                } else {
                    currentUserAchievements.pointGoal = 0
                    currentUserAchievements.missesGoal = 0
                    currentUserAchievements.zeroToOneHundredGoal = 0
                    currentUserAchievements.skipsGoal = 0
                    currentUserAchievements.inARowGoal = 0
                    currentUserAchievements.millionInMinutesGoal = 0
                    currentUserAchievements.dropGoal = 0
                    currentUserAchievements.minutesOfTimeGoal = 0
                    currentUserAchievements.noComboGoal = 0
                    currentUserAchievements.hitsGoal = 0
                }
            }
        } catch {
            print("error")
        }
        return currentUserAchievements
    }
    
    func achievementsEarnedAtCurrentLevel(userAchievements: UserAchievementsObject, atLevel: Int) -> [Int] {
        var achievementsEarned = [Int]()
        
        if userAchievements.pointGoal > atLevel {
            achievementsEarned.append(0)
        }
        if userAchievements.missesGoal > atLevel {
            achievementsEarned.append(1)
        }
        if userAchievements.zeroToOneHundredGoal > atLevel {
            achievementsEarned.append(2)
        }
        if userAchievements.skipsGoal > atLevel {
            achievementsEarned.append(3)
        }
        if userAchievements.inARowGoal > atLevel {
            achievementsEarned.append(4)
        }
        if userAchievements.millionInMinutesGoal > atLevel {
            achievementsEarned.append(5)
        }
        if userAchievements.dropGoal > atLevel {
            achievementsEarned.append(6)
        }
        if userAchievements.minutesOfTimeGoal > atLevel {
            achievementsEarned.append(7)
        }
        if userAchievements.noComboGoal > atLevel {
            achievementsEarned.append(8)
        }
        if userAchievements.hitsGoal > atLevel {
            achievementsEarned.append(9)
        }
        return achievementsEarned
    }
    
    func determineNewUserAchievements(score: HighScore) -> UserAchievementsObject {
        let currentAchievementLevel = UserPrefs.currentAchievementLevel
        var currentAchievementLevelString = String()
        
        switch currentAchievementLevel {
        case 0:
           currentAchievementLevelString = "bronzeGoal"
        case 1:
            currentAchievementLevelString = "silverGoal"
        case 2:
            currentAchievementLevelString = "goldGoal"
        default:
            print("something went wrong determining the currentAchievementLevel")
        }
        
        let newUserAchievementsObject = UserAchievementsObject()
        if let pointGoal = AchievementDataHelper.achievements["pointGoal"]![currentAchievementLevelString] as? Double {
            print("point goal")
            if Double(GameVariables.score) >= pointGoal {
                print("new PointsGoal Achieved")
                newUserAchievementsObject.pointGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("pointGoal")
            }
        }
        if let missesGoal = AchievementDataHelper.achievements["missesGoal"]![currentAchievementLevelString] as? Double {
            if Double(GameVariables.missedDrops) >= missesGoal {
                print("new missedDropsGoaloal Achieved")
                newUserAchievementsObject.pointGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("missesGoal")
            }
        }
        if let zeroToOneHundredGoal = AchievementDataHelper.achievements["zeroToOneHundredGoal"]![currentAchievementLevelString] as? Double {
            if GameVariables.mostMissesWithOneHundredHit <= zeroToOneHundredGoal {
                print("new zeroToOneHundredGoal Achieved")
                newUserAchievementsObject.zeroToOneHundredGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("zeroToOneHundredGoal")
            }
        }
        if let skipsGoal = AchievementDataHelper.achievements["skipsGoal"]![currentAchievementLevelString] as? Double {
            if Double(GameVariables.skippedLevelUps) >= skipsGoal {
                print("new skipsGoal Achieved")
                newUserAchievementsObject.skipsGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("skipsGoal")
            }
        }
        if let inARowGoal = AchievementDataHelper.achievements["inARowGoal"]![currentAchievementLevelString] as? Double {
            if Double(GameVariables.longestStreak) >= inARowGoal {
                print("new inARowGoal Achieved")
                newUserAchievementsObject.inARowGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("inARowGoal")
            }
        }
        if let millionInMinutesGoal = AchievementDataHelper.achievements["millionInMinutesGoal"]![currentAchievementLevelString] as? Double {
            if Double(GameVariables.score) >= millionInMinutesGoal && Double(GameVariables.time) < 600 {
                print("new millionInMinutesGoal Achieved")
                newUserAchievementsObject.millionInMinutesGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("millionInMinutesGoal")
            }
        }
        if let dropGoal = AchievementDataHelper.achievements["dropGoal"]![currentAchievementLevelString] as? Double {
            if Double(GameVariables.bestDrop) >= dropGoal {
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
        if let noComboGoal = AchievementDataHelper.achievements["noComboGoal"]![currentAchievementLevelString] as? Double {
            if Double(GameVariables.score) >= noComboGoal && Double(GameVariables.longestStreak) == 0 {
                print("new noComboGoal Achieved")
                newUserAchievementsObject.noComboGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("noComboGoal")
            }
        }
        if let hitsGoal = AchievementDataHelper.achievements["hitsGoal"]![currentAchievementLevelString] as? Double {
            if Double(GameVariables.poppedDrops) >= hitsGoal {
                print("new hitsGoal Achieved")
                newUserAchievementsObject.hitsGoal = currentAchievementLevel + 1
                GameVariables.newAchievementsToDisplay.append("hitsGoal")
            }
        }
        return newUserAchievementsObject
    }
}
