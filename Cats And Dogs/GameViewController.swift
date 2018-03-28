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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentView), name: NSNotification.Name(rawValue: "showController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentEnterNameViewController), name: NSNotification.Name(rawValue: "showEnterNameViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentStatsViewController), name: NSNotification.Name(rawValue: "presentStatsViewController"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        print("GameVariables.gameIsActive: \(GameVariables.gameIsActive)")
        if !GameVariables.gameIsActive {
            if let view = self.view as! SKView? {
                print("viewWillLayoutSubviews called")
                if let scene = SKScene(fileNamed: "HomeScene") {
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for segue called")
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
        print("called")
        self.performSegue(withIdentifier: "toMyController", sender: self)
    }
    
    @objc func presentEnterNameViewController() {
        self.performSegue(withIdentifier: "showEnterNameVC", sender: self)
    }
    
    @objc func presentStatsViewController() {
        self.performSegue(withIdentifier: "gameViewToScoreStatsSegue", sender: self)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
