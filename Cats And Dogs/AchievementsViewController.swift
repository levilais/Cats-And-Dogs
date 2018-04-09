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
            label.text = "\(achievementLevel.kmFormatted)" + " " + achievement.textTag
        }
    }
    
    @IBAction func achievementButtonDidPress(_ sender: Any) {
        let button = sender as! UIButton
        print("\(button.tag) button")
        Utilities().showCustomPopup(achievementLevelShowing: achievementLevelShowing, buttonTag: button.tag, presentingVC: self)
    }
    
    @IBAction func bronzeToggleDidPress(_ sender: Any) {
        print("bronze toggle pressed")
        achievementLevelShowing = 0
        setupAchievementsForLevelShowing()
    }
    
    @IBAction func silverToggleDidPress(_ sender: Any) {
        print("silver toggle pressed")
        achievementLevelShowing = 1
        setupAchievementsForLevelShowing()
    }
    
    @IBAction func goldToggleDidPress(_ sender: Any) {
        print("gold toggle pressed")
        achievementLevelShowing = 2
        setupAchievementsForLevelShowing()
    }
    
    @IBAction func xButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
