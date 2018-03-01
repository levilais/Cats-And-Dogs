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
    var missLabel: SKLabelNode?
    
    var ground: SKSpriteNode?
    var bgImage: SKSpriteNode?
    var gauge: SKSpriteNode?
    var gaugeFill: SKSpriteNode?
    var pauseButton: SKSpriteNode?
    
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
        missLabel = childNode(withName: "missLabel") as? SKLabelNode
        
        gauge = childNode(withName: "gauge") as? SKSpriteNode
        gauge?.texture = SKTexture(imageNamed: "gauge.pdf")
        
        gaugeFill = childNode(withName: "gaugeFill") as? SKSpriteNode
        
        ground = childNode(withName: "ground") as? SKSpriteNode
        ground?.physicsBody?.categoryBitMask = groundCategory
        ground?.physicsBody?.contactTestBitMask = dropCategory
        
        pauseButton = childNode(withName: "pauseButton") as? SKSpriteNode
        pauseButton?.name = "pauseButton"
        pauseButton?.zPosition = .infinity
        
        scene?.childNode(withName: "playButton")?.isHidden = true
        scene?.childNode(withName: "quitButton")?.isHidden = true
        scene?.childNode(withName: "settingsButton")?.isHidden = true
        scene?.childNode(withName: "pauseLabel")?.isHidden = true
        
        setGameState()
        startDropTimer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name {
                switch name {
                case "drop":
                    print("drop touched")
                    if let drop = touchedNode as? Drop {
                        if let dropLetter = drop.type {
                            self.determineStreak(dropLetter: dropLetter)
                            self.computeScore()
                            drop.removeFromParent()
                        }
                    }
                case "pauseButton":
                    pauseGame()
                case "playButton":
                    resumeGame()
                case "quitButton":
                    if let view = self.view as! SKView? {
                        if let gameScene = SKScene(fileNamed: "HomeScene") {
                            gameScene.scaleMode = .aspectFill
                            view.presentScene(gameScene)
                        }
                    }
                default:
                    print("no button touched")
                }
            }
        }
    }
    
    func setGameState() {
        GameVariables.score = 0
        GameVariables.missesLeft = GameControls.missMeterLimit
        
        self.scoreLabel?.text = String(GameVariables.score)
        self.missLabel?.text = String(GameVariables.missesLeft)
    }
    
    func determineStreak(dropLetter: String) {
        self.isCombo = false
        switch dropLetter {
        case Drop.DropType.C.rawValue:
            if GameVariables.streak != "CAT" && GameVariables.streak != "DOG" {
                GameVariables.multiplier = 1
                if !GameVariables.firstDrop {
                    updateMissMeter(changeValue: -1)
                }
            }
            GameVariables.streak = "C"
        case Drop.DropType.A.rawValue:
            if GameVariables.streak == "C" {
                GameVariables.streak = "CA"
            } else {
                GameVariables.streak = ""
                GameVariables.multiplier = 1
                updateMissMeter(changeValue: -1)
            }
        case Drop.DropType.T.rawValue:
            if GameVariables.streak == "CA" {
                GameVariables.streak = "CAT"
                isCombo = true
                GameVariables.multiplier += 1
                updateMissMeter(changeValue: 5)
            } else {
                GameVariables.streak = ""
                GameVariables.multiplier = 1
                updateMissMeter(changeValue: -1)
            }
        case Drop.DropType.D.rawValue:
            if GameVariables.streak != "CAT" && GameVariables.streak != "DOG" {
                GameVariables.multiplier = 1
                if !GameVariables.firstDrop {
                    updateMissMeter(changeValue: -1)
                }
            }
            GameVariables.streak = "D"
        case Drop.DropType.O.rawValue:
            if GameVariables.streak == "D" {
                GameVariables.streak = "DO"
            } else {
                GameVariables.streak = ""
                GameVariables.multiplier = 1
                updateMissMeter(changeValue: -1)
            }
        case Drop.DropType.G.rawValue:
            if GameVariables.streak == "DO" {
                GameVariables.streak = "DOG"
                isCombo = true
                GameVariables.multiplier += 1
                updateMissMeter(changeValue: 5)
            } else {
                GameVariables.streak = ""
                GameVariables.multiplier = 1
                updateMissMeter(changeValue: -1)
            }
        default:
            print("default called")
        }
        
        if GameVariables.multiplier > 1 {
            streakLabel?.text = String(GameVariables.multiplier) + "x \(GameVariables.streak)"
        } else {
            streakLabel?.text = GameVariables.streak
        }
        if GameVariables.firstDrop == true {
            GameVariables.firstDrop = false
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
        drop.name = "drop"
        
        drop.physicsBody = SKPhysicsBody(rectangleOf: drop.size)
        drop.physicsBody?.affectedByGravity = false
        
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = groundCategory
        addChild(drop)
        
        let maxStartingX = size.width / 2 - drop.size.width / 2 - 40
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
        
        let dropThenPopAction = SKAction.sequence([moveDown])
        drop.run(dropThenPopAction)
    }
    
    func updateMissMeter(changeValue: Int) {
        var valueToChange = changeValue
        var isGameOver = false
        
        if abs(changeValue) >= GameVariables.missesLeft {
            isGameOver = true
        } else {
            if changeValue >= GameVariables.missesLeft {
                if valueToChange == 100 {
                    valueToChange = 0
                } else {
                    valueToChange = GameVariables.missesLeft
                }
            }
        }
        if !isGameOver {
            if (GameVariables.missesLeft + valueToChange) > 100 {
                valueToChange = 100 - GameVariables.missesLeft
            }
            
            GameVariables.missesLeft += valueToChange
            if let gaugeFillCheck = gaugeFill {
                let currentY = gaugeFillCheck.frame.midY
                let newHeight = (GameControls.missMeterLimit - GameVariables.missesLeft) * 4
                
                let newY = currentY - CGFloat(valueToChange) * 2
                let newPoint = CGPoint(x: gaugeFillCheck.frame.midX, y: newY)
                
                gaugeFillCheck.scale(to: CGSize(width: gaugeFillCheck.size.width, height: CGFloat(newHeight)))
                gaugeFillCheck.position = newPoint
            }
            self.missLabel?.text = String(GameVariables.missesLeft)
        } else {
            gameOver()
        }
    }
    
    func gameOver() {
        self.missLabel?.text = "0"
        dropTimer?.invalidate()
        if let sceneCheck = scene {
            for child in sceneCheck.children {
                if let name = child.name {
                    switch name {
                    case "drop":
                        child.removeFromParent()
                    case "pauseButton","missLabel","gauge","gaugeFill","scoreLabel","streakLabel":
                        child.isHidden = true
                    default:
                        print("do nothing")
                    }
                }
            }
        }
    }
    
    func pauseGame() {
        dropTimer?.invalidate()
        if let sceneCheck = scene {
            sceneCheck.isPaused = true
            for child in sceneCheck.children {
                if let name = child.name {
                    switch name {
                    case "pauseButton","missLabel","gauge","gaugeFill","scoreLabel","streakLabel","drop":
                        child.isHidden = true
                    case "pauseLabel","playButton","settingsButton","quitButton":
                        child.isHidden = false
                    default:
                        print("do nothing")
                    }
                }
            }
        }
    }
    
    func resumeGame() {
        if let sceneCheck = scene {
            sceneCheck.isPaused = false
            for child in sceneCheck.children {
                if let name = child.name {
                    switch name {
                    case "pauseButton","missLabel","gauge","gaugeFill","scoreLabel","streakLabel","drop":
                        child.isHidden = false
                    case "pauseLabel","playButton","settingsButton","quitButton":
                        child.isHidden = true
                    default:
                        print("do nothing")
                    }
                }
            }
        }
        startDropTimer()
    }
    
    func startDropTimer() {
        dropTimer = Timer.scheduledTimer(withTimeInterval: GameControls.dropFrequency, repeats: true, block: { (timer) in
            self.createDrop()
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == dropCategory {
            updateMissMeter(changeValue: -2)
            contact.bodyA.node?.removeFromParent()
            print("bodyA")
        }
        if contact.bodyB.categoryBitMask == dropCategory {
            updateMissMeter(changeValue: -2)
            contact.bodyB.node?.removeFromParent()
            print("bodyB")
        }
    }
}
