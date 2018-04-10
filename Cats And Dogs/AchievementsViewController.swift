//
//  AchievementsViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 4/7/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {

    @IBOutlet weak var backgroundBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var bronzeToggle: UIButton!
    @IBOutlet weak var silverToggle: UIButton!
    @IBOutlet weak var goldToggle: UIButton!
    
    @IBOutlet var achievementButtons: [UIButton]!
    @IBOutlet var achievementLabels: [UILabel]!
    
    var viewLaidOut = false
    var achievementLevelShowing = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        achievementLevelShowing = UserPrefs.currentAchievementLevel
        setupAchievementsForLevelShowing()
    }
    
    override func viewWillLayoutSubviews() {
        if !viewLaidOut {
            backgroundBottomLayout.constant -= (self.view.safeAreaInsets.bottom)
            viewLaidOut = true
        }
    }
    
    func setupAchievementsForLevelShowing() {
        for label in self.achievementLabels {
            let achievementString = Achievement().achievementNameFromInt(tag: label.tag)
            let achievement = Achievement().achievementObjectFromString(achievementName: achievementString)
            
            var achievementLevel = Double()
            var achievementColor = UIColor()
            
            switch achievementLevelShowing {
            case 0:
                achievementLevel = achievement.bronzeGoal
                achievementColor = UIColor.StyleFile.bronzeColor
            case 1:
                achievementLevel = achievement.silverGoal
                achievementColor = UIColor.StyleFile.silverColor
            case 2:
                achievementLevel = achievement.goldGoal
                achievementColor = UIColor.StyleFile.goldColor
            default:
                print("error")
            }
            
            label.textColor = achievementColor
            
            if label.tag != 7 {
                label.text = "\(achievementLevel.kmFormatted)" + " " + achievement.textTag
            } else {
                label.text = "\((Int(achievementLevel / 60)))" + " " + achievement.textTag
            }
        }
        
        
        let currentUserAchievements = UserAchievementsObject().currentUserAchievementsObject()
        
        let achievementsEarned = UserAchievementsObject().achievementsEarnedAtCurrentLevel(userAchievements: currentUserAchievements, atLevel: achievementLevelShowing)
        
        for button in self.achievementButtons {
            var nameString = Achievement().achievementNameFromInt(tag: button.tag)
            if achievementsEarned.contains(button.tag) {
                nameString += String(achievementLevelShowing + 1)
            } else {
                nameString += String(0)
            }
             button.setBackgroundImage(UIImage(named: nameString), for: .normal)
        }
    }
    
    @IBAction func achievementButtonDidPress(_ sender: Any) {
        let button = sender as! UIButton
        print("\(button.tag) button")
        let title = determinePopupTitle(achievementLevelShowing: achievementLevelShowing, buttonTag: button.tag)
        let body = determinePopupBodyText(achievementLevelShowing: achievementLevelShowing, buttonTag: button.tag)
        Utilities().showCustomPopup(title: title, body: body, presentingVC: self)
    }
    
    func determinePopupTitle(achievementLevelShowing: Int, buttonTag: Int) -> String {
        var titleText = String()
        
        let achievementName = Achievement().achievementNameFromInt(tag: buttonTag)
        let achievement = Achievement().achievementObjectFromString(achievementName: achievementName)
        
        var achievementLevel = Double()
        switch achievementLevelShowing {
        case 0:
            achievementLevel = achievement.bronzeGoal
        case 1:
            achievementLevel = achievement.silverGoal
        case 2:
            achievementLevel = achievement.goldGoal
        default:
            print("error")
        }
        
        if buttonTag != 7 {
            titleText = "\(achievementLevel.kmFormatted)" + " " + achievement.textTag
        } else {
            titleText = "\((Int(achievementLevel / 60)))" + " " + achievement.textTag
        }
        return titleText
    }
    
    func determinePopupBodyText(achievementLevelShowing: Int, buttonTag: Int) -> String {
        var bodyText = String()
        
        let achievementName = Achievement().achievementNameFromInt(tag: buttonTag)
        let achievement = Achievement().achievementObjectFromString(achievementName: achievementName)
        
        var achievementLevel = Double()
        switch achievementLevelShowing {
        case 0:
            achievementLevel = achievement.bronzeGoal
        case 1:
            achievementLevel = achievement.silverGoal
        case 2:
            achievementLevel = achievement.goldGoal
        default:
            print("error")
        }
        
        if buttonTag != 7 {
            if let number = achievementLevel as? NSNumber {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                if let numberString = numberFormatter.string(from: number) {
                    bodyText = achievement.detailDescriptionBeginning + " " + numberString + " " +  achievement.detailDescriptionEnd
                }
            }
        } else {
            bodyText = achievement.detailDescriptionBeginning + " " + "\((Int(achievementLevel / 60)))" + " " +  achievement.detailDescriptionEnd
        }
        return bodyText
    }
    
    @IBAction func bronzeToggleDidPress(_ sender: Any) {
        achievementLevelShowing = 0
        setupAchievementsForLevelShowing()
    }
    
    @IBAction func silverToggleDidPress(_ sender: Any) {
        if UserPrefs.currentAchievementLevel > 0 {
            achievementLevelShowing = 1
            setupAchievementsForLevelShowing()
        } else {
            print("silver locked")
            Utilities().showCustomPopup(title: "Silver Level Locked", body: "You'll need to complete all Bronze level achievements in order to unlock the Silver level.", presentingVC: self)
        }
    }
    
    @IBAction func goldToggleDidPress(_ sender: Any) {
        if UserPrefs.currentAchievementLevel > 1 {
            achievementLevelShowing = 2
            setupAchievementsForLevelShowing()
        } else {
            print("gold locked")
            Utilities().showCustomPopup(title: "Gold Level Locked", body: "You'll need to complete all Bronze and Silver level achievements in order to unlock the Gold level.", presentingVC: self)
        }
    }
    
    @IBAction func xButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
