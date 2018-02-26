//
//  GameScene.swift
//  Cats And Dogs
//
//  Created by Levi on 2/25/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode?
    var streakLabel: SKLabelNode?
    var ground: SKSpriteNode?
    var backgroundImage = SKSpriteNode(imageNamed: "background.pdf")
    
    // Game Variables
    var dropTimer: Timer?
    var dropFrequency = TimeInterval()
    var dropSpeed = TimeInterval()
    var score = Int()
    
    // Physics World Categories
    let dropCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    let category3: UInt32 = 0x1 << 3
    let coinManCategory: UInt32 = 0x1 << 4
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        backgroundImage.position = CGPoint(x: 0, y: 0)
        backgroundImage.zPosition = -1
        addChild(backgroundImage)
        
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        streakLabel = childNode(withName: "streakLabel") as? SKLabelNode
        
        ground = childNode(withName: "ground") as? SKSpriteNode
        ground?.physicsBody?.categoryBitMask = groundCategory
        ground?.physicsBody?.contactTestBitMask = dropCategory
        
        dropTimer = Timer.scheduledTimer(withTimeInterval: GameControls.dropFrequency, repeats: true, block: { (timer) in
            self.createDrop()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            if let touchedNode = self.atPoint(positionInScene) as? Drop {
                if let dropLetter = touchedNode.type {
                    self.determineStreak(dropLetter: dropLetter)
                    
                }
                touchedNode.removeFromParent()
            }
        }
    }
    
    func determineStreak(dropLetter: String) {
        switch dropLetter {
        case Drop.DropType.C.rawValue:
            GameVariables.streak = "C"
        case Drop.DropType.A.rawValue:
            if GameVariables.streak == "C" {
                GameVariables.streak = "CA"
            } else {
                GameVariables.streak = ""
            }
        case Drop.DropType.T.rawValue:
            if GameVariables.streak == "CA" {
                GameVariables.streak = "CAT"
            } else {
                GameVariables.streak = ""
            }
        case Drop.DropType.D.rawValue:
            GameVariables.streak = "D"
        case Drop.DropType.O.rawValue:
            if GameVariables.streak == "D" {
                GameVariables.streak = "DO"
            } else {
                GameVariables.streak = ""
            }
        case Drop.DropType.G.rawValue:
            if GameVariables.streak == "DO" {
                GameVariables.streak = "DOG"
            } else {
                GameVariables.streak = ""
            }
        default:
            print("default called")
        }
        streakLabel?.text = GameVariables.streak
        print("Current Streak: \(GameVariables.streak)")
    }
    
    func createDrop() {
        let drop = Drop()
        // Will likely need to create drop shape later
        drop.physicsBody = SKPhysicsBody(rectangleOf: drop.size)
        drop.physicsBody?.affectedByGravity = false
        
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = groundCategory
        addChild(drop)
        
        let maxStartingX = size.width / 2 - drop.size.width / 2
        let minStartingX = -size.width / 2 + drop.size.width / 2
        let startingXRange = maxStartingX - minStartingX
        let startingX = maxStartingX - CGFloat(arc4random_uniform(UInt32(startingXRange)))
        
        let startingY: CGFloat = size.height / 2 + drop.size.height / 2
        drop.position = CGPoint(x: startingX, y: startingY)
        
        let moveDown = SKAction.moveBy(x: 0, y: -size.height - drop.size.height, duration: GameControls.dropSpeed)
        drop.run(moveDown)
        
        let removeDrop = SKAction.removeFromParent()
        let dropThenPopAction = SKAction.sequence([moveDown,removeDrop])
        drop.run(dropThenPopAction)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Where we pop drops on the ground
        if contact.bodyA.categoryBitMask == dropCategory {
            contact.bodyA.node?.removeFromParent()
            print("bodyA")
        }
        if contact.bodyB.categoryBitMask == dropCategory {
            contact.bodyB.node?.removeFromParent()
            print("bodyB")
        }
        score += 1
        scoreLabel?.text = String(score)
    }
}
