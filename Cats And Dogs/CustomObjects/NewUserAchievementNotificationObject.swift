//
//  NewUserAchievementNotificationObject.swift
//  Cats And Dogs
//
//  Created by Levi on 4/11/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import UIKit

class NewUserAchievementNotificationObject {
    var achievementTitle: String!
    var image: UIImage!
    var textColor: UIColor!
    
    var title1: String?
    var title2: String?
    var isLevelUpNotification = false
    var isAllAchievementsNotification = false
    
    func newAchievementNotificationObjectFromAchievementString(achievement: String) -> NewUserAchievementNotificationObject {
        let goalObject = Achievement().achievementObjectFromString(achievementName: achievement)
        let achievementNotificationObject = NewUserAchievementNotificationObject()
        
        var achievementTitle = String()
        if achievement != "minutesOfTimeGoal" {
            achievementTitle = "\(goalObject.currentGoal.kmFormatted)" + " " + goalObject.textTag
        } else {
            achievementTitle = "\((Int(goalObject.currentGoal / 60)))" + " " + goalObject.textTag
        }
        
        achievementNotificationObject.achievementTitle = achievementTitle
        
        switch UserPrefs.currentAchievementLevel {
        case 0:
            achievementNotificationObject.image = UIImage(named: "\(goalObject.name!)1")
            achievementNotificationObject.textColor = UIColor.StyleFile.bronzeColor
        case 1:
            achievementNotificationObject.image = UIImage(named: "\(goalObject.name!)2")
            achievementNotificationObject.textColor = UIColor.StyleFile.silverColor
        case 2:
            achievementNotificationObject.image = UIImage(named: "\(goalObject.name!)3")
            achievementNotificationObject.textColor = UIColor.StyleFile.goldColor
        default:
            print("error")
        }
        
        return achievementNotificationObject
    }
    
    
    func showNewAchievementPopup(presentingVC: UIViewController) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newAchievementPopupViewControllerID") as! NewAchievementPopupViewController
        presentingVC.addChildViewController(popupVC)
        let frame = CGRect(x: presentingVC.view.frame.minX, y: presentingVC.view.frame.minY, width: presentingVC.view.frame.width, height: (presentingVC.view.frame.height + presentingVC.view.safeAreaInsets.bottom))
        popupVC.view.frame = frame
        presentingVC.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: presentingVC)
        
        let newUserAchievementNotification = GameVariables.newAchievementsToDisplay[0]
        
        if newUserAchievementNotification.isLevelUpNotification {
            popupVC.titleLabel1.text = "Achievements"
            popupVC.titleLabel2.text = "Unlocked!"
            popupVC.achievementButton.setBackgroundImage(UIImage(named: "newAchievementBackground" + "\(UserPrefs.currentAchievementLevel)"), for: .normal)
            
            
            switch UserPrefs.currentAchievementLevel {
            case 1:
                popupVC.achievementTitleLabel.text = "Silver Level"
                popupVC.achievementTitleLabel.textColor = UIColor.StyleFile.silverColor
                popupVC.buttonImageView.image = UIImage(named: "silverDrop")
            case 2:
                if GameVariables.achievementLevelUpTriggered {
                    popupVC.achievementTitleLabel.text = "Gold Level"
                    popupVC.achievementTitleLabel.textColor = UIColor.StyleFile.goldColor
                    popupVC.buttonImageView.image = UIImage(named: "goldDrop")
                }
            default:
                print("error")
            }
        } else if newUserAchievementNotification.isAllAchievementsNotification {
            popupVC.titleLabel1.text = "You Have Every"
            popupVC.titleLabel2.text = "Achievement!"
            popupVC.achievementButton.setBackgroundImage(UIImage(named: "newAchievementBackground2"), for: .normal)
            popupVC.achievementTitleLabel.text = "Congrats!"
            popupVC.achievementTitleLabel.textColor = UIColor.StyleFile.goldColor
            popupVC.buttonImageView.image = UIImage(named: "allAchievements")
        } else {
            popupVC.titleLabel1.text = "New"
            popupVC.titleLabel2.text = "Achievement!"
            var imageName = String()
            if !GameVariables.achievementLevelUpTriggered {
                imageName = "newAchievementBackground" + String(UserPrefs.currentAchievementLevel)
            } else {
                switch UserPrefs.currentAchievementLevel {
                case 1:
                    imageName = "newAchievementBackground0"
                case 2:
                    imageName = "newAchievementBackground1"
                default:
                    print("error")
                }
            }
            popupVC.achievementButton.setBackgroundImage(UIImage(named: imageName), for: .normal)
            popupVC.buttonImageView.image = newUserAchievementNotification.image
            popupVC.achievementTitleLabel.text = newUserAchievementNotification.achievementTitle
            popupVC.achievementTitleLabel.textColor = newUserAchievementNotification.textColor
        }
        
        GameVariables.newAchievementsToDisplay.remove(at: 0)
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn], animations: {
            popupVC.popupBackground.alpha = 1.0
            popupVC.displayView.alpha = 1.0
            popupVC.displayView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        })
    }
    
    func dismissViewController(viewController: UIViewController) {
        if GameVariables.newAchievementsToDisplay.count > 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentCustomPopup"), object: nil)
        }
        viewController.view.removeFromSuperview()
    }
}
