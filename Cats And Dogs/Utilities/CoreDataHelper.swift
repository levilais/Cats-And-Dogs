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
    
    func saveHighScore(score: Int, playerName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newHighScore = NSEntityDescription.insertNewObject(forEntityName: "HighScores", into: context)
        
        newHighScore.setValue(playerName, forKey: "playerName")
        newHighScore.setValue(score, forKey: "score")
        newHighScore.setValue(Date(), forKey: "timestamp")
        
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
