//
//  GameViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 2/25/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    // Atmosphere
    var backgroundMusic = SKAudioNode()
    var subviewsLaidOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentView), name: NSNotification.Name(rawValue: "showController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentEnterNameViewController), name: NSNotification.Name(rawValue: "showEnterNameViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentStatsViewController), name: NSNotification.Name(rawValue: "presentStatsViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentToAchievementController), name: NSNotification.Name(rawValue: "presentToAchievementController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentCustomPopup), name: NSNotification.Name(rawValue: "presentCustomPopup"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        if !subviewsLaidOut {
            if !GameVariables.gameIsActive {
                if let view = self.view as! SKView? {
                    if let scene = SKScene(fileNamed: "HomeScene") {
                        scene.scaleMode = .aspectFill
                        view.presentScene(scene)
                    }
                    view.ignoresSiblingOrder = true
                }
            }
            subviewsLaidOut = true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameViewToScoreStatsSegue" {
            if let destinationVC = segue.destination as? ScoreStatsViewController {
                destinationVC.isComingFromGameOverScene = true
            }
        }
        
        if segue.identifier == "showEnterNameVC" {
            if let destinationVC = segue.destination as? EnterNameViewController {
                if let gameOverHighScore = GameVariables.gameOverHighScore {
                    destinationVC.highScoreToUpdateNameOn = gameOverHighScore
                }
            }
        }
    }
    
    @objc func presentView() {
        self.performSegue(withIdentifier: "toMyController", sender: self)
    }
    
    @objc func presentEnterNameViewController() {
        self.performSegue(withIdentifier: "showEnterNameVC", sender: self)
    }
    
    @objc func presentStatsViewController() {
        self.performSegue(withIdentifier: "gameViewToScoreStatsSegue", sender: self)
    }
    
    @objc func presentToAchievementController() {
        self.performSegue(withIdentifier: "toAchievementController", sender: self)
    }
    
    @objc func presentCustomPopup() {        
        let newUserAchievementObject = NewUserAchievementNotificationObject()
        newUserAchievementObject.achievementTitle = "25M Points"
        newUserAchievementObject.image = UIImage(named: "pointGoal3")
        newUserAchievementObject.textColor = UIColor.StyleFile.goldColor
        
        NewUserAchievementNotificationObject().showNewAchievementPopup(newUserAchievementNotification: newUserAchievementObject, presentingVC: self)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
