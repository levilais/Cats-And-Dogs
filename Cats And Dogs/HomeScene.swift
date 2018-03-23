//
//  HomeScene.swift
//  Cats And Dogs
//
//  Created by Levi on 2/28/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit
import SpriteKit

class HomeScene: SKScene {
    
    var bgImage: SKSpriteNode?
    var homePlaybutton: SKSpriteNode?
    var settingsButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        bgImage = childNode(withName: "bgImage") as? SKSpriteNode
        bgImage?.texture = SKTexture(imageNamed: "background.pdf")
        bgImage?.zPosition = -1
        
        homePlaybutton = childNode(withName: "homePlayButton") as? SKSpriteNode
        homePlaybutton?.size = Utilities().resizeDropSpaceSize(view: view, currentSize: (homePlaybutton?.size)!)
        let pulseUp = SKAction.scale(to: 1.02, duration: 1.5)
        let pulseDown = SKAction.scale(to: 0.988, duration: 1.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        self.homePlaybutton?.run(repeatPulse)
        
        settingsButton = childNode(withName: "settingsButton") as? SKSpriteNode
        settingsButton?.position = Utilities().shiftHorizontal(view: view, currentPosition: (settingsButton?.position)!)
        settingsButton?.position = Utilities().shiftDown(view: view, currentPosition: (settingsButton?.position)!)
        Utilities().resizespriteNode(spriteNode: settingsButton!, view: view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name {
                switch name {
                case "homePlayButton":
                    if let view = self.view as! SKView? {
                        if let gameScene = SKScene(fileNamed: "GameScene") {
                            gameScene.scaleMode = .aspectFill
                            view.presentScene(gameScene)
                        }
                    }
                case "settingsButton":
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showController"), object: nil)
                default:
                    print("no button touched")
                }
            }
        }
    }
}
