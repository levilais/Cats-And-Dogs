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
    
    func showNewAchievementPopup(newUserAchievementNotification: NewUserAchievementNotificationObject, presentingVC: UIViewController) {
        
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newAchievementPopupViewControllerID") as! NewAchievementPopupViewController
        presentingVC.addChildViewController(popupVC)
        let frame = CGRect(x: presentingVC.view.frame.minX, y: presentingVC.view.frame.minY, width: presentingVC.view.frame.width, height: (presentingVC.view.frame.height + presentingVC.view.safeAreaInsets.bottom))
        popupVC.view.frame = frame
        presentingVC.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: presentingVC)
        
        if newUserAchievementNotification.isLevelUpNotification {
            if let title1 = newUserAchievementNotification.title1 {
                popupVC.titleLabel1.text = title1
            }
            if let title2 = newUserAchievementNotification.title2 {
                popupVC.titleLabel2.text = title2
            }
        } else {
            popupVC.titleLabel1.text = "New"
            popupVC.titleLabel2.text = "Achievement!"
        }
        
        popupVC.achievementButton.setImage(newUserAchievementNotification.image, for: .normal)
        popupVC.achievementTitleLabel.text = newUserAchievementNotification.achievementTitle
        popupVC.achievementTitleLabel.textColor = newUserAchievementNotification.textColor
        
        popupVC.popupBackground.alpha = 1.0
        UIView.animate(withDuration: 0.1, delay: 0.2, options: [.curveEaseIn], animations: {
            popupVC.displayView.alpha = 1.0
            popupVC.displayView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        })
    }
    
    func dismissViewController(viewController: UIViewController) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
            viewController.view.alpha = 0
            
        }, completion: { (completed) in
            viewController.view.removeFromSuperview()
        })
        
    }
    
}
