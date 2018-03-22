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
        newHighScore.setValue(highScore.timestamp, forKey: "timestamp")
        newHighScore.setValue(highScore.level, forKey: "level")
        newHighScore.setValue(highScore.skippedLevelUps, forKey: "skippedLevelUps")
        newHighScore.setValue(highScore.longestStreak, forKey: "longestStreak")
        newHighScore.setValue(highScore.bestDrop, forKey: "bestDrop")
        newHighScore.setValue(highScore.poppedDrops, forKey: "poppedDrops")
        newHighScore.setValue(highScore.missedDrops, forKey: "missedDrops")
        newHighScore.setValue(highScore.accuracy, forKey: "accuracy")
        newHighScore.setValue(highScore.combos, forKey: "combos")
        newHighScore.setValue(highScore.identifier, forKey: "identifier")
        
        do {
            try context.save()
        } catch {
            print("there was an error")
        }
    }
    
    func setLastNameUsed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                let result = results[0] as! NSManagedObject
                if let name = result.value(forKey: "playerName") as? String {
                    var nameToSave = name
                    if nameToSave == "Unsigned" {
                        nameToSave = "Tap Here To Sign"
                    }
                    GameVariables.lastNameUsed = nameToSave
                }
            }
        } catch {
            print("couldn't fetch results")
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
                    if let identifier = result.value(forKey: "identifier") as? String {
                        highScore.identifier = identifier
                    }
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
    
    func scoreRecord() -> String? {
        var recordScore = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "score", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var highScores = [Int]()
                for result in results as! [NSManagedObject] {
                    if let score = result.value(forKey: "score") as? Int {
                        highScores.append(score)
                    }
                }
                recordScore = highScores[0]
            }
        } catch {
            print("couldn't fetch results")
        }
        
        var scoreString = String()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: recordScore as NSNumber) {
            scoreString = String(formattedNumber)
        }
        
        return "Record: \(scoreString)"
    }
    
    func scoreRank(highScore: HighScore) -> String? {
        var scoreRank = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "score", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var highScores = [Int]()
                for result in results as! [NSManagedObject] {
                    if let score = result.value(forKey: "score") as? Int {
                        highScores.append(score)
                    }
                }
                if let rank = highScores.index(of: highScore.score) {
                    scoreRank = rank
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let rankString: String = "Rank: " + NumberFormatter.localizedString(from: NSNumber(value: (scoreRank + 1)), number: .ordinal)
        
        return rankString
    }
    
    func timeRecord() -> String? {
        var recordTime = Date()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var recordTimes = [Date]()
                for result in results as! [NSManagedObject] {
                    if let time = result.value(forKey: "timestamp") as? Date {
                        recordTimes.append(time)
                    }
                }
                recordTime = recordTimes[0]
            }
        } catch {
            print("couldn't fetch results")
        }
        
        var timeString = String()
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
        formatter.allowedUnits = [ .hour, .minute, .second ]
        if let formattedDuration = formatter.string(from: recordTime.timeIntervalSinceNow) {
            if recordTime.timeIntervalSinceNow > 60 {
                timeString = "\(formattedDuration)"
            } else {
                timeString = "\(formattedDuration) Seconds"
            }
        }
        
        return "Record: \(timeString)"
    }
    
    func timeRank(highScore: HighScore) -> String? {
        var timeRank = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var recordTimes = [Date]()
                for result in results as! [NSManagedObject] {
                    if let time = result.value(forKey: "timestamp") as? Date {
                        recordTimes.append(time)
                    }
                }
                if let rank = recordTimes.index(of: highScore.timestamp) {
                    timeRank = rank
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let rankString: String = "Rank: " + NumberFormatter.localizedString(from: NSNumber(value: (timeRank + 1)), number: .ordinal)
        
        return rankString
    }
    
    func levelRecord() -> String? {
        var recordLevel = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "level", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var recordLevels = [Int]()
                for result in results as! [NSManagedObject] {
                    if let level = result.value(forKey: "level") as? Int {
                        recordLevels.append(level)
                    }
                }
                recordLevel = recordLevels[0]
            }
        } catch {
            print("couldn't fetch results")
        }
        
        return "Record: Level \(recordLevel)"
    }
    
    func levelRank(highScore: HighScore) -> String? {
        var levelRank = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "level", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var recordLevels = [Int]()
                for result in results as! [NSManagedObject] {
                    if let level = result.value(forKey: "level") as? Int {
                        recordLevels.append(level)
                    }
                }
                if let rank = recordLevels.index(of: highScore.level) {
                    levelRank = rank
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let rankString: String = "Rank: " + NumberFormatter.localizedString(from: NSNumber(value: (levelRank + 1)), number: .ordinal)
        
        return rankString
    }
    
    func skippedRecord() -> String? {
        var recordSkipped = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "skippedLevelUps", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var skippedLevels = [Int]()
                for result in results as! [NSManagedObject] {
                    if let skippedCount = result.value(forKey: "skippedLevelUps") as? Int {
                        skippedLevels.append(skippedCount)
                    }
                }
                recordSkipped = skippedLevels[0]
            }
        } catch {
            print("couldn't fetch results")
        }
        
        return "Record: \(recordSkipped)"
    }
    
    func skippedRank(highScore: HighScore) -> String? {
        var skippedRank = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "skippedLevelUps", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var skippedLevels = [Int]()
                for result in results as! [NSManagedObject] {
                    if let skippedCount = result.value(forKey: "skippedLevelUps") as? Int {
                        skippedLevels.append(skippedCount)
                    }
                }
                if let rank = skippedLevels.index(of: highScore.skippedLevelUps) {
                    skippedRank = rank
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let rankString: String = "Rank: " + NumberFormatter.localizedString(from: NSNumber(value: (skippedRank + 1)), number: .ordinal)
        
        return rankString
    }
    
    func hitsRecord() -> String? {
        var recordHits = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "poppedDrops", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var recordHitsArray = [Int]()
                for result in results as! [NSManagedObject] {
                    if let hitCount = result.value(forKey: "poppedDrops") as? Int {
                        recordHitsArray.append(hitCount)
                    }
                }
                recordHits = recordHitsArray[0]
            }
        } catch {
            print("couldn't fetch results")
        }
        
        var hitsString = String()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: recordHits as NSNumber) {
            hitsString = "\(formattedNumber)"
        }
        
        return "Record: \(hitsString)"
    }
    
    func hitsRank(highScore: HighScore) -> String? {
        var hitsRank = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "poppedDrops", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var recordHitsArray = [Double]()
                for result in results as! [NSManagedObject] {
                    if let hitCount = result.value(forKey: "poppedDrops") as? Double {
                        recordHitsArray.append(hitCount)
                    }
                }
                if let rank = recordHitsArray.index(of: highScore.poppedDrops) {
                    hitsRank = rank
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let rankString: String = "Rank: " + NumberFormatter.localizedString(from: NSNumber(value: (hitsRank + 1)), number: .ordinal)
        
        return rankString
    }
    
    func missesRecord() -> String? {
        var recordMisses = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "missedDrops", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var recordMissesArray = [Int]()
                for result in results as! [NSManagedObject] {
                    if let missesCount = result.value(forKey: "missedDrops") as? Int {
                        recordMissesArray.append(missesCount)
                    }
                }
                recordMisses = recordMissesArray[0]
            }
        } catch {
            print("couldn't fetch results")
        }
        
        var missesString = String()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: recordMisses as NSNumber) {
            missesString = "\(formattedNumber)"
        }
        
        return "Record: \(missesString)"
    }
    
    func missesRank(highScore: HighScore) -> String? {
        var missesRank = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "missedDrops", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var recordMissesArray = [Double]()
                for result in results as! [NSManagedObject] {
                    if let missesCount = result.value(forKey: "missedDrops") as? Double {
                        recordMissesArray.append(missesCount)
                    }
                }
                if let rank = recordMissesArray.index(of: highScore.missedDrops) {
                    missesRank = rank
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let rankString: String = "Rank: " + NumberFormatter.localizedString(from: NSNumber(value: (missesRank + 1)), number: .ordinal)
        
        return rankString
    }
    
    func accuracyRecord() -> String? {
        var recordAccuracy = Double()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "accuracy", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var accuracyArray = [Double]()
                for result in results as! [NSManagedObject] {
                    if let accuracy = result.value(forKey: "accuracy") as? Double {
                        accuracyArray.append(accuracy)
                    }
                }
                recordAccuracy = accuracyArray[0]
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let accuracyString = String("\(Int(100*(recordAccuracy.rounded(toPlaces: 2))))%")
        
        return "Record: \(accuracyString)"
    }
    
    func accuracyRank(highScore: HighScore) -> String? {
        var accuracyRank = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "accuracy", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var accuracyArray = [Double]()
                for result in results as! [NSManagedObject] {
                    if let accuracy = result.value(forKey: "accuracy") as? Double {
                        accuracyArray.append(accuracy)
                    }
                }
                if let rank = accuracyArray.index(of: highScore.accuracy) {
                    accuracyRank = rank
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let rankString: String = "Rank: " + NumberFormatter.localizedString(from: NSNumber(value: (accuracyRank + 1)), number: .ordinal)
        
        return rankString
    }
    
    func combosRecord() -> String? {
        var recordCombos = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "combos", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var combosArray = [Int]()
                for result in results as! [NSManagedObject] {
                    if let combos = result.value(forKey: "combos") as? Int {
                        combosArray.append(combos)
                    }
                }
                recordCombos = combosArray[0]
            }
        } catch {
            print("couldn't fetch results")
        }
        
        var comboString = String()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: recordCombos as NSNumber) {
            comboString = "\(formattedNumber)"
        }
        
        return "Record: \(comboString)"
    }
    
    func combosRank(highScore: HighScore) -> String? {
        var combosRank = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "combos", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var combosArray = [Int]()
                for result in results as! [NSManagedObject] {
                    if let combos = result.value(forKey: "combos") as? Int {
                        combosArray.append(combos)
                    }
                }
                if let rank = combosArray.index(of: highScore.combos) {
                    combosRank = rank
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let rankString: String = "Rank: " + NumberFormatter.localizedString(from: NSNumber(value: (combosRank + 1)), number: .ordinal)
        
        return rankString
    }
    
    func streakRecord() -> String? {
        var recordStreak = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "longestStreak", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var streakArray = [Int]()
                for result in results as! [NSManagedObject] {
                    if let streaks = result.value(forKey: "longestStreak") as? Int {
                        streakArray.append(streaks)
                    }
                }
                recordStreak = streakArray[0]
            }
        } catch {
            print("couldn't fetch results")
        }
        
        var streakString = String()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: recordStreak as NSNumber) {
            streakString = "\(formattedNumber)"
        }
        
        return "Record: \(streakString)"
    }
    
    func streakRank(highScore: HighScore) -> String? {
        var streakRank = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "longestStreak", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var streakArray = [Int]()
                for result in results as! [NSManagedObject] {
                    if let streaks = result.value(forKey: "longestStreak") as? Int {
                        streakArray.append(streaks)
                    }
                }
                if let rank = streakArray.index(of: highScore.longestStreak) {
                    streakRank = rank
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let rankString: String = "Rank: " + NumberFormatter.localizedString(from: NSNumber(value: (streakRank + 1)), number: .ordinal)
        
        return rankString
    }
    
    func bestDropRecord() -> String? {
        var recordBestDrop = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "bestDrop", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var bestDropArray = [Int]()
                for result in results as! [NSManagedObject] {
                    if let bestDrop = result.value(forKey: "bestDrop") as? Int {
                        bestDropArray.append(bestDrop)
                    }
                }
                recordBestDrop = bestDropArray[0]
            }
        } catch {
            print("couldn't fetch results")
        }
        
        var bestDropString = String()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: recordBestDrop as NSNumber) {
            bestDropString = "\(formattedNumber)"
        }
        
        return "Record: \(bestDropString)"
    }
    
    func bestDropRank(highScore: HighScore) -> String? {
        var bestDropRank = Int()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        let sort = NSSortDescriptor(key: "bestDrop", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                var bestDropArray = [Int]()
                for result in results as! [NSManagedObject] {
                    if let bestDrop = result.value(forKey: "bestDrop") as? Int {
                        bestDropArray.append(bestDrop)
                    }
                }
                if let rank = bestDropArray.index(of: highScore.bestDrop) {
                    bestDropRank = rank
                }
            }
        } catch {
            print("couldn't fetch results")
        }
        
        let rankString: String = "Rank: " + NumberFormatter.localizedString(from: NSNumber(value: (bestDropRank + 1)), number: .ordinal)
        
        return rankString
    }
    
    func updateName(highScore: HighScore, newName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", highScore.identifier)
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                if results.count != 0{
                    
                    let managedObject = results[0]
                    
                    var nameToSave = newName
                    if nameToSave == "Tap Here To Sign" {
                        nameToSave = "Unsigned"
                    }
                    
                    managedObject.setValue(nameToSave, forKey: "playerName")
                    do {
                        try context.save()
                    } catch {
                        print("couldn't save")
                    }
                }
            }
        } catch {
            print("couldn't fetch results")
        }
    }
}
