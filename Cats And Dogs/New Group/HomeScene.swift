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
    var timeToDrop: Double = 0
    var timeToRain: Double = 0
    var elapsedTime: TimeInterval = 0.0
    var lastTimeStamp: TimeInterval = 0.0
    var dropToCreate = 0
    
    var introElapsedTime: TimeInterval = 0.0
    var introLastTimeStamp: TimeInterval = 0.0
    var timeToStartDrums = 0.0
    var introTimerRunning = true
    
    var ground: SKSpriteNode?
    var water: SKSpriteNode?
    var introLabel: SKLabelNode?
    
    // Physics World Categories
    let dropCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    
    override func didMove(to view: SKView) {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appDidEnterForeground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        if UserPrefs.rainAllowed {
            if let rainAudioPlayer = GameAudio.rainAudioPlayer {
                rainAudioPlayer.play()
            }
            if let thunderAudioPlayer = GameAudio.thunderAudioPlayer {
                thunderAudioPlayer.play()
            }
        }
    
        bgImage = childNode(withName: "bgImage") as? SKSpriteNode
        bgImage?.texture = SKTexture(imageNamed: "background.pdf")
        bgImage?.zPosition = -1
        
        ground = childNode(withName: "ground") as? SKSpriteNode
        ground?.physicsBody?.categoryBitMask = groundCategory
        ground?.physicsBody?.contactTestBitMask = dropCategory
        
        if super.view?.safeAreaInsets.bottom != 0 {
            water = childNode(withName: "water") as? SKSpriteNode
            water?.zPosition = 100
            water?.position.y += ((water?.size.height)! + (super.view?.safeAreaInsets.bottom)!)
            ground?.position.y += ((water?.size.height)! - 20)
        }
    }
    
//    func introAnimation() {
//        self.introLabel?.position = CGPoint(x: 0, y: frame.height / 4)
//        self.introLabel?.alpha = 0
//        scene?.addChild(self.introLabel!)
//
//        let wait = SKAction.wait(forDuration: 1)
//        let show = SKAction.fadeIn(withDuration: 0.1)
//        let animateImageChange = SKAction.animate(with: self.introLabelTextures, timePerFrame: 1)
//        let sequence = SKAction.sequence([wait, show, animateImageChange])
//        self.introLabel?.run(sequence) {
//            self.introLabel?.alpha = 0
//            self.introLabel = SKSpriteNode(texture: self.introLabelTextures[0])
//            self.gauge?.alpha = 1
//            self.gaugeFill?.alpha = 1
//            self.scoreLabel?.alpha = 1
//            self.missLabel?.alpha = 1
//            self.levelTrackerBackground?.alpha = 1
//            self.multipleTrackerBackground?.alpha = 1
//            self.missMeterTrackerBackground?.alpha = 1
//
//            self.levelTrackerLabel?.alpha = 1
//            self.multipleTrackerLabel?.alpha = 1
//            self.startGame()
//            self.startGameCalled = true
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name {
                switch name {
                case "playDrop":
                    if let drums = GameAudio.drumsAudioPlayer {
                        drums.setVolume(0.0, fadeDuration: 0.1)
                    }
                    
                    GameAudio().soundThunderStrike(scene: self)
                    if let view = self.view {
                        if let gameScene = SKScene(fileNamed: "GameScene") {
                            gameScene.scaleMode = .aspectFill
                            view.presentScene(gameScene)
                        }
                    }
                case "settingsDrop":
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showController"), object: nil)
                case "achievementsDrop":
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentToAchievementController"), object: nil)
                default:
                    print("no button touched")
                }
            }
        }
    }
    
    func createDrop() {
        var drop = Drop()
        drop = Drop().createHomeScreenDrop(drop: drop, type: dropToCreate)
        
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = groundCategory
        drop.physicsBody?.collisionBitMask = 0
        
        if let view = self.view {
            Utilities().resizespriteNode(spriteNode: drop, view: view)
        }
        
        addChild(drop)
        DropFunctions().moveDrop(drop: drop, scene: self, view: self.view!)
        
        if dropToCreate < 2 {
            dropToCreate += 1
        } else {
            dropToCreate = 0
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if UserPrefs.musicAllowed {
            if introTimerRunning == true {
                var difference = TimeInterval()
                if introLastTimeStamp != 0.0 {
                    difference = currentTime - introLastTimeStamp
                }
                
                introElapsedTime += difference
                introLastTimeStamp = currentTime
                print("introElapsedTime: \(introElapsedTime)")
                
                if timeToStartDrums == 0 {
                    timeToStartDrums = currentTime
                } else if currentTime - timeToStartDrums > 5.0 {
                    if let drums = GameAudio.drumsAudioPlayer {
                        if !drums.isPlaying {
                            drums.play()
                        }
                    }
                    introTimerRunning = false
                }
            }
        }
        
        
        var difference = TimeInterval()
        if lastTimeStamp != 0.0 {
            difference = currentTime - lastTimeStamp
        }
        
        elapsedTime += difference
        lastTimeStamp = currentTime
        
        if timeToDrop == 0 {
            timeToDrop = currentTime
        } else if currentTime - timeToDrop > 3 {
            createDrop()
            timeToDrop = currentTime
        }
        
        if timeToRain == 0 {
            timeToRain = currentTime
        } else if currentTime - timeToRain > GameControls.rainFrequency {
            GameEnvironment().createSmallDrop(scene: self, view: view!)
            timeToRain = currentTime
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == dropCategory {
            if let drop = contact.bodyB.node as? Drop {
                DropFunctions().animateSplash(dropToSplash: drop, scene: self)
            }
        }
        if contact.bodyB.categoryBitMask == dropCategory {
            if var drop = contact.bodyB.node as? Drop {
                DropFunctions().animateSplash(dropToSplash: drop, scene: self)
            }
        }
    }
    
    @objc func appDidEnterForeground() {
        if let rainAudioPlayer = GameAudio.rainAudioPlayer {
            rainAudioPlayer.play()
        }
        if let thunderAudioPlayer = GameAudio.thunderAudioPlayer {
            thunderAudioPlayer.play()
        }
    }
}
