//
//  CoreDataHelper.swift
//  Cats And Dogs
//
//  Created by Levi on 3/17/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    
    func saveHighScore(highScore: HighScore) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newHighScore = NSEntityDescription.insertNewObject(forEntityName: "HighScores", into: context)
        
        newHighScore.setValue(highScore.playerName, forKey: "playerName")
        newHighScore.setValue(highScore.score, forKey: "score")
        newHighScore.setValue(Date(), forKey: "timestamp")
        newHighScore.setValue(highScore.level, forKey: "level")
        newHighScore.setValue(highScore.skippedLevelUps, forKey: "skippedLevelUps")
        newHighScore.setValue(highScore.longestStreak, forKey: "longestStreak")
        newHighScore.setValue(highScore.bestDrop, forKey: "bestDrop")
        newHighScore.setValue(highScore.poppedDrops, forKey: "poppedDrops")
        newHighScore.setValue(highScore.missedDrops, forKey: "missedDrops")
        newHighScore.setValue(highScore.accuracy, forKey: "accuracy")
        newHighScore.setValue(highScore.combos, forKey: "combos")
        newHighScore.setValue(Double(highScore.time), forKey: "time")
        
        do {
            try context.save()
            print("saved")
        } catch {
            print("there was an error")
        }
    }
    
    func getHighScores() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "score", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var newScores = [HighScore]()
                for result in results as! [NSManagedObject] {
                    let highScore = HighScore()
                    if let score = result.value(forKey: "score") as? Int {
                        highScore.score = score
                    }
                    if let playerName = result.value(forKey: "playerName") as? String {
                        highScore.playerName = playerName
                    }
                    if let timestamp = result.value(forKey: "timestamp") as? Date {
                        highScore.timestamp = timestamp
                    }
                    if let level = result.value(forKey: "level") as? Int {
                        highScore.level = level
                    }
                    if let skippedLevelUps = result.value(forKey: "skippedLevelUps") as? Int {
                        highScore.skippedLevelUps = skippedLevelUps
                    }
                    if let longestStreak = result.value(forKey: "longestStreak") as? Int {
                        highScore.longestStreak = longestStreak
                    }
                    if let bestDrop = result.value(forKey: "bestDrop") as? Int {
                        highScore.bestDrop = bestDrop
                    }
                    if let poppedDrops = result.value(forKey: "poppedDrops") as? Double {
                        highScore.poppedDrops = poppedDrops
                    }
                    if let missedDrops = result.value(forKey: "missedDrops") as? Double {
                        highScore.missedDrops = missedDrops
                    }
                    if let accuracy = result.value(forKey: "accuracy") as? Double {
                        highScore.accuracy = accuracy
                    }
                    if let combos = result.value(forKey: "combos") as? Int {
                        highScore.combos = combos
                    }
                    if let time = result.value(forKey: "time") as? Double {
                        highScore.time = TimeInterval(time)
                    }
                    newScores.append(highScore)
                }
                HighScoresClass.highScores = newScores
            } else {
                print("no results")
            }
        } catch {
            print("couldn't fetch results")
        }
    }
}
