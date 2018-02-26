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
    var bgImage: SKSpriteNode?
    
    // Game Variables
    var dropTimer: Timer?
    var isCombo = false
    var lastDropXValue: CGFloat?
    var lastDropYValue: CGFloat?
    
    // Physics World Categories
    let dropCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        bgImage = childNode(withName: "bgImage") as? SKSpriteNode
        bgImage?.texture = SKTexture(imageNamed: "background.pdf")
        bgImage?.zPosition = -1

        
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
                    self.computeScore()
                }
                touchedNode.removeFromParent()
            }
        }
    }
    
    func determineStreak(dropLetter: String) {
        self.isCombo = false
        switch dropLetter {
        case Drop.DropType.C.rawValue:
            if GameVariables.streak != "CAT" && GameVariables.streak != "DOG" {
                GameVariables.multiplier = 1
            }
            GameVariables.streak = "C"
        case Drop.DropType.A.rawValue:
            if GameVariables.streak == "C" {
                GameVariables.streak = "CA"
            } else {
                GameVariables.streak = ""
                GameVariables.multiplier = 1
            }
        case Drop.DropType.T.rawValue:
            if GameVariables.streak == "CA" {
                GameVariables.streak = "CAT"
                isCombo = true
                GameVariables.multiplier += 1
            } else {
                GameVariables.streak = ""
                GameVariables.multiplier = 1
            }
        case Drop.DropType.D.rawValue:
            if GameVariables.streak != "CAT" && GameVariables.streak != "DOG" {
                GameVariables.multiplier = 1
            }
            GameVariables.streak = "D"
        case Drop.DropType.O.rawValue:
            if GameVariables.streak == "D" {
                GameVariables.streak = "DO"
            } else {
                GameVariables.streak = ""
                GameVariables.multiplier = 1
            }
        case Drop.DropType.G.rawValue:
            if GameVariables.streak == "DO" {
                GameVariables.streak = "DOG"
                isCombo = true
                GameVariables.multiplier += 1
            } else {
                GameVariables.streak = ""
                GameVariables.multiplier = 1
            }
        default:
            print("default called")
        }
        
        if GameVariables.multiplier > 1 {
            streakLabel?.text = String(GameVariables.multiplier) + "x \(GameVariables.streak)"
        } else {
            streakLabel?.text = GameVariables.streak
        }
    }
    
    func computeScore() {
        var newPoints = Int()
        if isCombo {
            newPoints = GameControls.baseComboPoints * GameVariables.multiplier
        } else {
            newPoints = GameControls.baseSingleLetterPoints * GameVariables.multiplier
        }
        GameVariables.score += newPoints
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value:GameVariables.score)) {
            scoreLabel?.text = formattedNumber
        }
    }
    
    func createDrop() {
        let drop = Drop()
        drop.physicsBody = SKPhysicsBody(rectangleOf: drop.size)
        drop.physicsBody?.affectedByGravity = false
        
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = groundCategory
        addChild(drop)
        
        let maxStartingX = size.width / 2 - drop.size.width / 2
        let minStartingX = -size.width / 2 + drop.size.width / 2
        let startingXRange = maxStartingX - minStartingX
        
        var startingX = CGFloat()
        if let lastX = self.lastDropXValue {
            var startingXFound = false
            while !startingXFound {
                startingX = maxStartingX - CGFloat(arc4random_uniform(UInt32(startingXRange)))
                if (startingX - drop.size.width)...(startingX + drop.size.width) ~= lastX {
                    print("too close")
                } else {
                    startingXFound = true
                }
            }
        } else {
            startingX = maxStartingX - CGFloat(arc4random_uniform(UInt32(startingXRange)))
        }

        let startingY: CGFloat = size.height / 2 + drop.size.height / 2 
        drop.position = CGPoint(x: startingX, y: startingY)
        
        self.lastDropXValue = startingX
        
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
        print("update water meter")
        // update water meter
    }
}
