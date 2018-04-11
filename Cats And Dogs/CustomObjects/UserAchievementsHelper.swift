//
//  UserAchievementsHelper.swift
//  Cats And Dogs
//
//  Created by Levi on 4/6/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserAchievementsHelper {
    
    func updateUserAchievements(newUserAchievements: UserAchievementsObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAchievements")
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    var accomplishedGoalCount = 0
                    
                    if let managedObject = results[0] as? UserAchievements {
                        if managedObject.pointGoal < newUserAchievements.pointGoal {
                            managedObject.setValue((newUserAchievements.pointGoal), forKey: "pointGoal")
                        }
                        if newUserAchievements.pointGoal == UserPrefs.currentAchievementLevel + 1 {
                            accomplishedGoalCount += 1
                        }
                        
                        if managedObject.missesGoal < newUserAchievements.missesGoal {
                            managedObject.setValue((newUserAchievements.missesGoal), forKey: "missesGoal")
                        }
                        
                        if newUserAchievements.missesGoal == UserPrefs.currentAchievementLevel + 1 {
                            accomplishedGoalCount += 1
                        }
                        
                        if managedObject.zeroToOneHundredGoal < newUserAchievements.zeroToOneHundredGoal {
                            managedObject.setValue((newUserAchievements.zeroToOneHundredGoal), forKey: "zeroToOneHundredGoal")
                        }
                        
                        if newUserAchievements.zeroToOneHundredGoal == UserPrefs.currentAchievementLevel + 1 {
                            accomplishedGoalCount += 1
                        }
                        
                        if managedObject.skipsGoal < newUserAchievements.skipsGoal {
                            managedObject.setValue((newUserAchievements.skipsGoal), forKey: "skipsGoal")
                        }
                        if newUserAchievements.skipsGoal == UserPrefs.currentAchievementLevel + 1 {
                            accomplishedGoalCount += 1
                        }
                        
                        if managedObject.inARowGoal < newUserAchievements.inARowGoal {
                            managedObject.setValue((newUserAchievements.inARowGoal), forKey: "inARowGoal")
                        }
                        if newUserAchievements.inARowGoal == UserPrefs.currentAchievementLevel + 1 {
                            accomplishedGoalCount += 1
                        }
                        
                        if managedObject.millionInMinutesGoal < newUserAchievements.millionInMinutesGoal {
                            managedObject.setValue((newUserAchievements.millionInMinutesGoal), forKey: "millionInMinutesGoal")
                        }
                        if newUserAchievements.millionInMinutesGoal == UserPrefs.currentAchievementLevel + 1 {
                            accomplishedGoalCount += 1
                        }
                        
                        if managedObject.dropGoal < newUserAchievements.dropGoal {
                            managedObject.setValue((newUserAchievements.dropGoal), forKey: "dropGoal")
                        }
                        if newUserAchievements.dropGoal == UserPrefs.currentAchievementLevel + 1 {
                            accomplishedGoalCount += 1
                        }
                        
                        if Int(managedObject.minutesOfTimeGoal) < Int(newUserAchievements.minutesOfTimeGoal) {
                            managedObject.setValue((newUserAchievements.minutesOfTimeGoal), forKey: "minutesOfTimeGoal")
                        }
                        if newUserAchievements.minutesOfTimeGoal == UserPrefs.currentAchievementLevel + 1 {
                            accomplishedGoalCount += 1
                        }
                        
                        if managedObject.noComboGoal < newUserAchievements.noComboGoal {
                            managedObject.setValue((newUserAchievements.noComboGoal), forKey: "noComboGoal")
                        }
                        if newUserAchievements.noComboGoal == UserPrefs.currentAchievementLevel + 1 {
                            accomplishedGoalCount += 1
                        }
                        
                        if managedObject.hitsGoal < newUserAchievements.hitsGoal {
                            managedObject.setValue((newUserAchievements.hitsGoal), forKey: "hitsGoal")
                        }
                        if newUserAchievements.hitsGoal == UserPrefs.currentAchievementLevel + 1 {
                            accomplishedGoalCount += 1
                        }
                        
                        do {
                            try context.save()
                        } catch {
                            print("couldn't save")
                        }
                        
                        if accomplishedGoalCount == 10 {
                            if UserPrefs.currentAchievementLevel < 2 {
                                UserPrefs().updateCurrentAchievementLevel()
                                let levelUpAchievement = NewUserAchievementNotificationObject()
                                levelUpAchievement.isLevelUpNotification = true
                                GameVariables.newAchievementsToDisplay.append(levelUpAchievement)
                            }
                        }
                    }
                } else {
                    if let entity = NSEntityDescription.entity(forEntityName: "UserAchievements", in: context) {
                        let managedObject = NSManagedObject(entity: entity, insertInto: context)
                        
                        managedObject.setValue((newUserAchievements.pointGoal), forKey: "pointGoal")
                        managedObject.setValue((newUserAchievements.missesGoal), forKey: "missesGoal")
                        managedObject.setValue((newUserAchievements.zeroToOneHundredGoal), forKey: "zeroToOneHundredGoal")
                        managedObject.setValue((newUserAchievements.skipsGoal), forKey: "skipsGoal")
                        managedObject.setValue((newUserAchievements.inARowGoal), forKey: "inARowGoal")
                        managedObject.setValue((newUserAchievements.millionInMinutesGoal), forKey: "millionInMinutesGoal")
                        managedObject.setValue((newUserAchievements.dropGoal), forKey: "dropGoal")
                        managedObject.setValue((newUserAchievements.minutesOfTimeGoal), forKey: "minutesOfTimeGoal")
                        managedObject.setValue((newUserAchievements.noComboGoal), forKey: "noComboGoal")
                        managedObject.setValue((newUserAchievements.hitsGoal), forKey: "hitsGoal")
                        
                        do {
                            try context.save()
                        } catch {
                            print("couldn't save")
                        }
                    }
                }
            }
        } catch {
            print("couldn't fetch results")
        }
    }
}
