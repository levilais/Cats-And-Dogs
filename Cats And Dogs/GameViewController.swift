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

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentView), name: NSNotification.Name(rawValue: "showController"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        if GameVariables.gameIsActive == false {
            if let view = self.view as! SKView? {
                print("viewWillLayoutSubviews called")
                if let scene = SKScene(fileNamed: "HomeScene") {
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                
                //            view.showsFPS = true
                //            view.showsNodeCount = true
            }
        }
    }
    
    @objc func presentView() {
        print("called")
        self.performSegue(withIdentifier: "toMyController", sender: self)
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
