//
//  GameEnvironment.swift
//  Cats And Dogs
//
//  Created by Levi on 3/31/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import SpriteKit

class GameEnvironment {
    static var timeForLightning = 30.0
    static var timeForLightningTriggered = false
    
    func createLightningAnimation(backgroundImage: SKSpriteNode, scene: SKScene) {
        let flashSprite = SKSpriteNode()
        flashSprite.size = backgroundImage.size
        flashSprite.position = backgroundImage.position
        flashSprite.zPosition = backgroundImage.zPosition
        backgroundImage.zPosition -= 1
        
        flashSprite.alpha = 0
        scene.addChild(flashSprite)
        
        var textureInt = 0
        let lightningEvent = SKAction.run {
            var lightningFrequencyFactor = Double()
            
            switch GameVariables.currentLevel {
            case 1:
                textureInt = Int(arc4random_uniform(2)) + 1
                lightningFrequencyFactor = 20
            case 2:
                textureInt = Int(arc4random_uniform(3)) + 1
                lightningFrequencyFactor = 15
            case 3:
                textureInt = Int(arc4random_uniform(4)) + 1
                lightningFrequencyFactor = 10
            case 4:
                textureInt = Int(arc4random_uniform(2)) + 4
                lightningFrequencyFactor = 6
            case 5:
                textureInt = Int(arc4random_uniform(2)) + 5
                lightningFrequencyFactor = 4
            default:
                let weight = Int(arc4random_uniform(9)) + 1
                if weight <= 5 {
                    textureInt = 6
                } else {
                    textureInt = Int(arc4random_uniform(6)) + 1
                }
                lightningFrequencyFactor = 2
            }
            
            flashSprite.texture = SKTexture(imageNamed: "lightning\(textureInt)")
            let randomDelayDouble = (Double(arc4random_uniform(UInt32(lightningFrequencyFactor)) + 1))
            GameEnvironment.timeForLightning = GameEnvironment.timeForLightning + randomDelayDouble
            
            let flashCount: Int = Int(arc4random_uniform(3) + 2)
            let flashWithDelay = SKAction.run {
                let randomFadeInDouble = Double(arc4random_uniform(2) + 1)
                let fadeInTimeInterval: TimeInterval = TimeInterval(randomFadeInDouble) * 0.1
                let randomFadeOutDouble = Double(arc4random_uniform(3) + 1)
                let fadeOutTimeInterval: TimeInterval = TimeInterval(randomFadeOutDouble) * 0.1
                let randomDelayDouble = Double(arc4random_uniform(9) + 3)
                let delayTimeInterval: TimeInterval = randomDelayDouble * 0.1
                
                let fadeIn = SKAction.fadeIn(withDuration: fadeInTimeInterval)
                let fadeOut = SKAction.fadeOut(withDuration: fadeOutTimeInterval)
                
                let delay = SKAction.wait(forDuration: delayTimeInterval)
                let sequence = SKAction.sequence([fadeIn,fadeOut,delay])
                flashSprite.run(sequence)
            }
            
            let pulseFlash = SKAction.repeat(flashWithDelay, count: flashCount)
            flashSprite.run(pulseFlash)
        }
        flashSprite.run(lightningEvent)
        GameEnvironment.timeForLightningTriggered = false
    }
    
    func createSmallDrop(scene: SKScene, view: SKView) {
        let drop = SKSpriteNode(imageNamed: "smallDrop")
        drop.name = "smallDrop"
        drop.zPosition = 0
        scene.addChild(drop)
        
        let currentSceneSize = scene.size
        let newSize = Utilities().resizeDropSpaceSize(view: view, currentSize: currentSceneSize)
        
        let maxStartingX = newSize.width / 2 - drop.size.width / 2
        let minStartingX = -newSize.width / 2 + drop.size.width / 2
        let startingXRange = maxStartingX - minStartingX
        
        let startingX: CGFloat = maxStartingX - CGFloat(arc4random_uniform(UInt32(startingXRange)))
        let startingY: CGFloat = scene.size.height / 2 + drop.size.height / 2
        drop.position = CGPoint(x: startingX, y: startingY)
        
        let moveDown = SKAction.moveBy(x: 0, y: -scene.size.height - drop.size.height, duration: 2)
        drop.run(moveDown)
        
        let removeDrop = SKAction.removeFromParent()
        
        let dropThenPopAction = SKAction.sequence([moveDown, removeDrop])
        drop.run(dropThenPopAction)
    }
}
