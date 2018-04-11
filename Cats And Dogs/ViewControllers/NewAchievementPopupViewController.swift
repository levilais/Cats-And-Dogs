//
//  NewAchievementPopupViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 4/11/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class NewAchievementPopupViewController: UIViewController {

    @IBOutlet weak var buttonImageView: UIImageView!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var achievementTitleLabel: UILabel!
    @IBOutlet weak var achievementButton: UIButton!
    @IBOutlet weak var popupBackground: UIView!
    @IBOutlet weak var displayView: UIView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func achievementButtonDidPress(_ sender: Any) {
        print("achievement button did press")
        performSegue(withIdentifier: "newAchievementPopupToAchievements", sender: self)
    }

    @IBAction func dismissDidPress(_ sender: Any) {
        NewUserAchievementNotificationObject().dismissViewController(viewController: self)
    }
}
