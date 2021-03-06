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
    var playWasPressed = false
    var quitWasConfirmed = false {
        didSet {
            if quitWasConfirmed {
                quitWasConfirmed = false
                if let backgroundMusic = GameAudio.backgroundMusicPlayer {
                    backgroundMusic.setVolume(0.0, fadeDuration: 2.0)
                }
                if UserPrefs.musicAllowed {
                    if let drums = GameAudio.drumsAudioPlayer {
                        drums.play()
                    }
                }
                if let view = self.view as! SKView? {
                    if let scene = SKScene(fileNamed: "HomeScene") {
                        scene.scaleMode = .aspectFill
                        view.presentScene(scene)
                    }
                    view.ignoresSiblingOrder = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentView), name: NSNotification.Name(rawValue: "showController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentEnterNameViewController), name: NSNotification.Name(rawValue: "showEnterNameViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentStatsViewController), name: NSNotification.Name(rawValue: "presentStatsViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentToAchievementController), name: NSNotification.Name(rawValue: "presentToAchievementController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentCustomPopup), name: NSNotification.Name(rawValue: "presentCustomPopup"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentTutorialViewController), name: NSNotification.Name(rawValue: "presentTutorialViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentConfirmationViewController), name: NSNotification.Name(rawValue: "presentConfirmationViewController"), object: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        if UserPrefs.tutorialHasBeenShown {
            if playWasPressed {
                playWasPressed = false
                if let view = self.view as! SKView? {
                    if let scene = SKScene(fileNamed: "GameScene") {
                        scene.scaleMode = .aspectFill
                        view.presentScene(scene)
                    }
                    view.ignoresSiblingOrder = true
                }
            }
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
        print("showController notification posted, presentView called")
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
    
    @objc func presentTutorialViewController() {
        playWasPressed = true
        self.performSegue(withIdentifier: "homeToTutorial", sender: self)
    }
    
    @objc func presentConfirmationViewController() {
        Utilities().showQuitConfirmPopup(presentingVC: self)
    }
    
    
    @objc func presentCustomPopup() {
        NewUserAchievementNotificationObject().showNewAchievementPopup(presentingVC: self)
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
