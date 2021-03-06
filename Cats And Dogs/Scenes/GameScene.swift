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
    var introLabel: SKSpriteNode?
    let introLabelTextures = [SKTexture(imageNamed: "popThoseDrops0"), SKTexture(imageNamed: "popThoseDrops1"), SKTexture(imageNamed: "popThoseDrops2")]
    
    // Game Variables
    var dropTimer: Timer?
    var rainTimer: Timer?
    var isCombo = false
    var lastDropXValue: CGFloat?
    var lastDropYValue: CGFloat?
    var startGameCalled = false
    
    // Physics World Categories
    let dropCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        bgImage = childNode(withName: "bgImage") as? SKSpriteNode
        bgImage?.texture = SKTexture(imageNamed: "background.pdf")
        bgImage?.zPosition = -1

        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel?.alpha = 0
        scoreLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (scoreLabel?.position)!)
        scoreLabel?.position = Utilities().shiftDown(view: view, currentPosition: (scoreLabel?.position)!)
        
        streakLabel = childNode(withName: "streakLabel") as? SKLabelNode
        streakLabel?.position = Utilities().shiftDown(view: view, currentPosition: (streakLabel?.position)!)
        
        missLabel = childNode(withName: "missLabel") as? SKLabelNode
        missLabel?.alpha = 0
        missLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (missLabel?.position)!)
        missLabel?.position = Utilities().shiftUp(view: view, currentPosition: (missLabel?.position)!)
        
        gauge = childNode(withName: "gauge") as? SKSpriteNode
        gauge?.texture = SKTexture(imageNamed: "gauge.pdf")
        gauge?.alpha = 0
        gauge?.position = Utilities().shiftHorizontal(view: view, currentPosition: (gauge?.position)!)
        gauge?.position = Utilities().shiftUp(view: view, currentPosition: (gauge?.position)!)
        
        gaugeFill = childNode(withName: "gaugeFill") as? SKSpriteNode
        gaugeFill?.alpha = 0
        gaugeFill?.position = Utilities().shiftHorizontal(view: view, currentPosition: (gaugeFill?.position)!)
        gaugeFill?.position = Utilities().shiftUp(view: view, currentPosition: (gaugeFill?.position)!)
        
        ground = childNode(withName: "ground") as? SKSpriteNode
        ground?.physicsBody?.categoryBitMask = groundCategory
        ground?.physicsBody?.contactTestBitMask = dropCategory
        
        pauseButton = childNode(withName: "pauseButton") as? SKSpriteNode
        pauseButton?.name = "pauseButton"
        pauseButton?.zPosition = .infinity
        pauseButton?.position = Utilities().shiftHorizontal(view: view, currentPosition: (pauseButton?.position)!)
        pauseButton?.position = Utilities().shiftDown(view: view, currentPosition: (pauseButton?.position)!)
        
        scene?.childNode(withName: "playButton")?.isHidden = true
        scene?.childNode(withName: "quitButton")?.isHidden = true
        scene?.childNode(withName: "settingsButton")?.isHidden = true
        scene?.childNode(withName: "pauseLabel")?.isHidden = true
        
        animateRain()
        introAnimation()
        print("didMove called")
    }
    
    
// things pile up when pause pressed - figure out what's going wrong
    func introAnimation() {
        self.introLabel = SKSpriteNode(texture: self.introLabelTextures[0])
        self.introLabel?.position = CGPoint(x: 0, y: frame.height / 4)
        self.introLabel?.alpha = 0
        scene?.addChild(self.introLabel!)

        let wait = SKAction.wait(forDuration: 1)
        let show = SKAction.fadeIn(withDuration: 0.1)
        let animateImageChange = SKAction.animate(with: self.introLabelTextures, timePerFrame: 1)
        let wait2 = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([wait, show, animateImageChange, wait2])
        self.introLabel?.run(sequence) {
            self.introLabel?.alpha = 0
            self.introLabel = SKSpriteNode(texture: self.introLabelTextures[0])
            self.gauge?.alpha = 1
            self.gaugeFill?.alpha = 1
            self.scoreLabel?.alpha = 1
            self.missLabel?.alpha = 1
            self.startGame()
            self.startGameCalled = true
        }
    }
    
    func startGame() {
        setGameState()
        startDropTimer()
        GameVariables.gameIsActive = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name {
                switch name {
                case "drop":
                    print("drop touched")
                    if var drop = touchedNode as? Drop {
                        drop = determineStreak(drop: drop)
                        drop = computeScore(drop: drop)
                        animateSplash(dropToSplash: drop)
                        animateDropScore(dropToScore: drop)
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
                case "settingsButton":
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showController"), object: nil)
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
    
    func determineStreak(drop: Drop) -> Drop {
        self.isCombo = false
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
                    isCombo = true
                    missMeterValueToChange = 5
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
                    isCombo = true
                    missMeterValueToChange = 5
                } else {
                    GameVariables.streak = ""
                    GameVariables.multiplier = 1
                    missMeterValueToChange = -1
                }
            default:
                print("default called")
            }
            updateMissMeter(changeValue: missMeterValueToChange)
            drop.missPoints = missMeterValueToChange
        }
        
        if GameVariables.multiplier > 1 {
            streakLabel?.text = String(GameVariables.multiplier) + "x \(GameVariables.streak)"
        } else {
            streakLabel?.text = GameVariables.streak
        }
        if GameVariables.firstDrop == true {
            GameVariables.firstDrop = false
        }
        return drop
    }
    
    func computeScore(drop: Drop) -> Drop {
        var newPoints = Int()
        if isCombo {
            newPoints = GameControls.baseComboPoints * GameVariables.multiplier
        } else {
            newPoints = GameControls.baseSingleLetterPoints * GameVariables.multiplier
        }
        
        drop.scorePoints = newPoints
        GameVariables.score += newPoints
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value:GameVariables.score)) {
            scoreLabel?.text = formattedNumber
        }
        
        return drop
    }
    
    func createDrop() {
        let drop = Drop()
        drop.name = "drop"
        
        drop.physicsBody = SKPhysicsBody(rectangleOf: drop.size)
        drop.physicsBody?.affectedByGravity = false
        drop.zPosition = 10
        
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = groundCategory
        addChild(drop)
        
        let currentSceneSize = scene?.size
        let newSize = Utilities().resizeDropSpaceSize(view: view!, currentSize: currentSceneSize!)
        
        let maxStartingX = newSize.width / 2 - drop.size.width / 2 - 40
        let minStartingX = -newSize.width / 2 + drop.size.width / 2
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
    
    func animateRain() {
        let rainFrequency: TimeInterval = 0.05
        let rainSpeed: TimeInterval = 1.5
        
        rainTimer = Timer.scheduledTimer(withTimeInterval: rainFrequency, repeats: true, block: { (timer) in
            self.createSmallDrop(speed: rainSpeed)
        })
    }
    
    func createSmallDrop(speed: TimeInterval) {
        let drop = SKSpriteNode(imageNamed: "smallDrop")
        drop.name = "smallDrop"
        drop.zPosition = 0
        addChild(drop)
        
        let maxStartingX = size.width / 2 - drop.size.width / 2
        let minStartingX = -size.width / 2 + drop.size.width / 2
        let startingXRange = maxStartingX - minStartingX

        let startingX: CGFloat = maxStartingX - CGFloat(arc4random_uniform(UInt32(startingXRange)))
        let startingY: CGFloat = size.height / 2 + drop.size.height / 2
        drop.position = CGPoint(x: startingX, y: startingY)
                
        let moveDown = SKAction.moveBy(x: 0, y: -size.height - drop.size.height, duration: 2)
        drop.run(moveDown)
        
        let removeDrop = SKAction.removeFromParent()
        
        let dropThenPopAction = SKAction.sequence([moveDown, removeDrop])
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
        rainTimer?.invalidate()
        if let sceneCheck = scene {
            for child in sceneCheck.children {
                if let name = child.name {
                    switch name {
                    case "drop":
                        child.removeFromParent()
                    case "pauseButton","missLabel","gauge","gaugeFill","scoreLabel","streakLabel":
                        child.isHidden = true
                    default:
                        print("default in game over called")
                    }
                }
            }
        }
        if let view = self.view as! SKView? {
            if let gameOverScene = SKScene(fileNamed: "GameOverScene") {
                gameOverScene.scaleMode = .aspectFill
                view.presentScene(gameOverScene)
            }
        }
    }
    
    func animateSplash(dropToSplash: Drop) {
        let splash = SKSpriteNode(texture: SKTexture(imageNamed: "0splash.pdf"))
        
        let splashArray = [SKTexture(imageNamed: "0splash.pdf"), SKTexture(imageNamed: "1splash.pdf"),SKTexture(imageNamed: "2splash.pdf")]
        
        splash.size = CGSize(width: 75, height: 34)
        
        let dropPosition = dropToSplash.position
        splash.position = dropPosition
        
        dropToSplash.removeFromParent()
        self.addChild(splash)
        let animateSplash = SKAction.repeat(SKAction.animate(with: splashArray, timePerFrame: 0.08), count: 1)
        splash.run(animateSplash) {
            splash.removeFromParent()
        }
    }
    
    func animateDropScore(dropToScore: Drop) {
        var missPointsExist = false
        if let missPoints = dropToScore.missPoints {
            if missPoints != 0 {
                missPointsExist = true
                let missMeterPointChangeLabel = SKLabelNode()
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
                self.addChild(missMeterPointChangeLabel)
                missMeterPointChangeLabel.run(moveAction)
                missMeterPointChangeLabel.run(fadeAction) {
                    missMeterPointChangeLabel.removeFromParent()
                }
            }
        }
        
        
        let dropScoreLabel = SKLabelNode()
        dropScoreLabel.fontColor = UIColor(red:0.88, green:0.73, blue:0.84, alpha:1.0)
        dropScoreLabel.fontName = "Righteous-Regular"
        dropScoreLabel.fontSize = 48
        if let dropScore = dropToScore.scorePoints {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let formattedNumber = numberFormatter.string(from: dropScore as! NSNumber) {
                dropScoreLabel.text = "+\(formattedNumber)"
            }
        }
        
        var y = dropToScore.position.y + 30
        if missPointsExist == true {
            y += 50
        }
        
        dropScoreLabel.position = CGPoint(x: dropToScore.position.x, y: y)
        let fadeAction = SKAction.fadeOut(withDuration: 1)
        let moveAction = SKAction.moveBy(x: 20, y: 20, duration: 1)
        self.addChild(dropScoreLabel)
        dropScoreLabel.run(moveAction)
        dropScoreLabel.run(fadeAction) {
            dropScoreLabel.removeFromParent()
        }
    }
    
    func pauseGame() {
        introLabel?.alpha = 0
        dropTimer?.invalidate()
        rainTimer?.invalidate()
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
                        print("default in pauseGame called")
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
                        print("default in resumeGame called")
                    }
                }
            }
        }
        
        if startGameCalled {
            startDropTimer()
        } else {
            introLabel?.alpha = 1
        }
        animateRain()
    }
    
    func startDropTimer() {
        dropTimer = Timer.scheduledTimer(withTimeInterval: GameControls.dropFrequency, repeats: true, block: { (timer) in
            self.createDrop()
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == dropCategory {
            if var drop = contact.bodyB.node as? Drop {
                updateMissMeter(changeValue: -2)
                drop.missPoints = -2
                animateSplash(dropToSplash: drop)
                animateDropScore(dropToScore: drop)
            }
        }
        if contact.bodyB.categoryBitMask == dropCategory {
            if var drop = contact.bodyB.node as? Drop {
                updateMissMeter(changeValue: -2)
                drop.missPoints = -2
                animateSplash(dropToSplash: drop)
                animateDropScore(dropToScore: drop)
            }
        }
    }
}
