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
        // GETTING DATA OUT
        // note that the request returns an "NSFetchRequestResult" object which we cast as an "NSManagedObject" which we then cast as whatever type of object we're pulling out (in this case, "username" is a String)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScores")
        //        request.predicate = NSPredicate(format: "age <= %@", 10)
        
        
        // By default when a request is run, the device will return "faults" instead of values. Most of the time, you'll need to do this so you can actually use the values.
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let score = result.value(forKey: "score") as? Int {
                        print (score)
                    }
                    if let playerName = result.value(forKey: "playerName") as? String {
                        
                        print (playerName)
                    }
                    if let timestamp = result.value(forKey: "timestamp") as? Date {
                        print (timestamp)
                    }
                }
            } else {
                print("no results")
            }
        } catch {
            print("couldn't fetch results")
        }
    }
}
