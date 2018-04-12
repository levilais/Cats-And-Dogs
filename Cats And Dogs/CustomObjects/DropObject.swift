//
//  DropObject.swift
//  Cats And Dogs
//
//  Created by Levi on 2/25/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Drop: SKSpriteNode {
    static var dropTypes = ["D","O","G","C","A","T"]
    static var lastDropXValue: CGFloat?
    
    var type: String!
    var scorePoints: Int?
    var missPoints: Int?
    var isComboDrop = false
    var streakString: String?
    var moveAnimation: SKAction!
    
    init() {
        let texture = SKTexture(imageNamed: "CDrop.pdf")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = "drop"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.zPosition = 10
    }

    func createLetterDrop(drop: Drop) -> Drop {
        let letterDrop = drop
        let randomDrop = Drop.dropTypes[Int(arc4random_uniform(6))]
        letterDrop.texture = SKTexture(imageNamed: "\(randomDrop)Drop.pdf")
        letterDrop.type = randomDrop
        return letterDrop
    }
    
    func createLevelDrop(drop: Drop) -> Drop {
        let levelDrop = drop
        levelDrop.texture = SKTexture(imageNamed: "\(-GameVariables.levelMissPoints)Drop.pdf")
        self.type = "levelDrop"
        return levelDrop
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    enum DropType: String {
        case D, O, G, C, A, T
    }
}

class DropFunctions {
    func moveDrop(drop: Drop, scene: SKScene, view: SKView) {
        let currentSceneSize = scene.size
        let newSize = Utilities().resizeDropSpaceSize(view: view, currentSize: currentSceneSize)
        
        let maxStartingX = newSize.width / 2 - drop.size.width / 2 - 30
        let minStartingX = -newSize.width / 2 + drop.size.width / 2
        let startingXRange = maxStartingX - minStartingX
        
        var startingX = CGFloat()
        if let lastX = Drop.lastDropXValue {
            var startingXFound = false
            while !startingXFound {
                startingX = maxStartingX - CGFloat(arc4random_uniform(UInt32(startingXRange)))
                if (startingX - (drop.size.width + 20))...(startingX + (drop.size.width + 20)) ~= lastX {
                    print("too close")
                } else {
                    startingXFound = true
                }
            }
        } else {
            startingX = maxStartingX - CGFloat(arc4random_uniform(UInt32(startingXRange)))
        }
        
        let startingY: CGFloat = scene.size.height / 2 + drop.size.height / 2
        drop.position = CGPoint(x: startingX, y: startingY)
        
        Drop.lastDropXValue = startingX
        
        let moveDown = SKAction.moveBy(x: 0, y: -scene.size.height - drop.size.height, duration: GameControls.initialDropDuration)
        drop.speed = GameVariables.dropSpeed
        drop.run(moveDown)
    }
    
    func animateSplash(dropToSplash: Drop, scene: SKScene) {
        let splash = SKSpriteNode(texture: SKTexture(imageNamed: "0splash.pdf"))
        
        let splashArray = [SKTexture(imageNamed: "0splash.pdf"), SKTexture(imageNamed: "1splash.pdf"),SKTexture(imageNamed: "2splash.pdf")]
        
        splash.size = CGSize(width: 75, height: 34)
        
        let dropPosition = dropToSplash.position
        splash.position = dropPosition
        
        dropToSplash.removeFromParent()
        scene.addChild(splash)
        
        let animateSplash = SKAction.repeat(SKAction.animate(with: splashArray, timePerFrame: 0.08), count: 1)
        splash.run(animateSplash) {
            splash.removeFromParent()
        }
    }
    
    func animateDropScore(dropToScore: Drop, scene: SKScene) {
        var missPointsExist = false
        if let missPoints = dropToScore.missPoints {
            if missPoints != 0 {
                missPointsExist = true
                let missMeterPointChangeLabel = SKLabelNode()
                missMeterPointChangeLabel.name = "missMeterPointChangeLabel"
                
                missMeterPointChangeLabel.fontColor = UIColor(red:0.67, green:0.77, blue:0.80, alpha:1.0)
                missMeterPointChangeLabel.fontName = "Righteous-Regular"
                missMeterPointChangeLabel.fontSize = 48
                if let missPointsAmount = dropToScore.missPoints {
                    if missPointsAmount == 5 {
                        missMeterPointChangeLabel.text = "+\(missPointsAmount)"
                    } else {
                        missMeterPointChangeLabel.text = "\(missPointsAmount)"
                    }
                }
                let y = dropToScore.position.y + 30
                missMeterPointChangeLabel.position = CGPoint(x: dropToScore.position.x, y: y)
                let fadeAction = SKAction.fadeOut(withDuration: 1)
                let moveAction = SKAction.moveBy(x: 20, y: 20, duration: 1)
                scene.addChild(missMeterPointChangeLabel)
                missMeterPointChangeLabel.run(moveAction)
                missMeterPointChangeLabel.run(fadeAction) {
                    missMeterPointChangeLabel.removeFromParent()
                }
            }
        }
        
        
        let dropScoreLabel = SKLabelNode()
        dropScoreLabel.name = "dropScoreLabel"
        dropScoreLabel.fontColor = UIColor(red:0.88, green:0.73, blue:0.84, alpha:1.0)
        dropScoreLabel.fontName = "Righteous-Regular"
        dropScoreLabel.fontSize = 48
        
        var y = dropToScore.position.y + 30
        if missPointsExist == true {
            y += 50
        }
        
        if let dropScore = dropToScore.scorePoints {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let formattedNumber = numberFormatter.string(from: dropScore as! NSNumber) {
                dropScoreLabel.text = "+\(formattedNumber)"
                
                if dropToScore.type == "levelDrop" {
                    let levelLabel = SKLabelNode()
                    levelLabel.name = "levelLabel"
                    levelLabel.fontColor = UIColor.StyleFile.Orange
                    levelLabel.fontName = "Righteous-Regular"
                    levelLabel.fontSize = 48
                    levelLabel.text = "Level \(GameVariables.currentLevel)"
                    let levelLabely = y + 60
                    
                    levelLabel.position = CGPoint(x: dropToScore.position.x, y: levelLabely)
                    let fadeAction = SKAction.fadeOut(withDuration: 1)
                    let moveAction = SKAction.moveBy(x: 20, y: 20, duration: 1)
                    scene.addChild(levelLabel)
                    levelLabel.run(moveAction)
                    levelLabel.run(fadeAction) {
                        levelLabel.removeFromParent()
                    }
                }
            }
        }
        
        dropScoreLabel.position = CGPoint(x: dropToScore.position.x, y: y)
        let fadeAction = SKAction.fadeOut(withDuration: 1)
        let moveAction = SKAction.moveBy(x: 20, y: 20, duration: 1)
        scene.addChild(dropScoreLabel)
        dropScoreLabel.run(moveAction)
        dropScoreLabel.run(fadeAction) {
            dropScoreLabel.removeFromParent()
        }
    }
    
    func determineStreak(drop: Drop, scene: SKScene) -> Drop {
        var missMeterValueToChange = Int()
        if let dropLetter = drop.type {
            switch dropLetter {
            case Drop.DropType.C.rawValue:
                if GameVariables.streak != "CAT" && GameVariables.streak != "DOG" {
                    GameVariables.multiplier = 1
                } else {
                    GameVariables.multiplier += 1
                }
                GameVariables.streak = "C"
            case Drop.DropType.A.rawValue:
                if GameVariables.streak == "C" {
                    GameVariables.streak = "CA"
                } else {
                    GameVariables.streak = ""
                    GameVariables.multiplier = 1
                    missMeterValueToChange = -1
                }
            case Drop.DropType.T.rawValue:
                if GameVariables.streak == "CA" {
                    GameVariables.streak = "CAT"
                    drop.isComboDrop = true
                    missMeterValueToChange = 5
                    GameVariables.combos += 1
                } else {
                    GameVariables.streak = ""
                    GameVariables.multiplier = 1
                    missMeterValueToChange = -1
                }
            case Drop.DropType.D.rawValue:
                if GameVariables.streak != "CAT" && GameVariables.streak != "DOG" {
                    GameVariables.multiplier = 1
                } else {
                    GameVariables.multiplier += 1
                }
                GameVariables.streak = "D"
            case Drop.DropType.O.rawValue:
                if GameVariables.streak == "D" {
                    GameVariables.streak = "DO"
                } else {
                    GameVariables.streak = ""
                    GameVariables.multiplier = 1
                    missMeterValueToChange = -1
                }
            case Drop.DropType.G.rawValue:
                if GameVariables.streak == "DO" {
                    GameVariables.streak = "DOG"
                    drop.isComboDrop = true
                    missMeterValueToChange = 5
                    GameVariables.combos += 1
                } else {
                    GameVariables.streak = ""
                    GameVariables.multiplier = 1
                    missMeterValueToChange = -1
                }
            default:
                print("default called")
            }
            if drop.isComboDrop {
                GameAudio().soundShake()
            }
            
            drop.missPoints = missMeterValueToChange
        }
        
        if GameVariables.multiplier > 1 {
            drop.streakString = String(GameVariables.multiplier) + "x \(GameVariables.streak)"
        } else {
            drop.streakString = GameVariables.streak
        }
        
        return drop
    }
    
    func computeScore(drop: Drop) -> Drop {
        var newPoints = Int()
        
        if drop.type != "levelDrop" {
            if drop.isComboDrop {
                newPoints = GameVariables.comboPoints * GameVariables.multiplier
            } else {
                newPoints = GameVariables.singleLetterPoints * GameVariables.multiplier
            }
        } else {
            newPoints = GameVariables.singleLetterPoints * 10
        }
        
        drop.scorePoints = newPoints
        GameVariables.score += newPoints
        if newPoints > GameVariables.bestDrop {
            GameVariables.bestDrop = newPoints
        }
        
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = NumberFormatter.Style.decimal
//        if let formattedNumber = numberFormatter.string(from: NSNumber(value:GameVariables.score)) {
//            scoreLabel?.text = formattedNumber
//        }
        
        return drop
    }
}
