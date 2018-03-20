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

    var timeToRain: Double = 0
    var timeToDrop: Double = 0
    var timeToLevelUp: Double = 0
    var elapsedLevelTime: Double = 0
    var timeToCreateLevelDrop: Bool = false
    
    var scoreLabel: SKLabelNode?
    var streakLabel: SKLabelNode?
    var missLabel: SKLabelNode?
    var levelTrackerLabel: SKLabelNode?
    var multipleTrackerLabel: SKLabelNode?
    var levelTrackerBackground: SKSpriteNode?
    var multipleTrackerBackground: SKSpriteNode?
    var missMeterTrackerBackground: SKSpriteNode?
    var missesLeftLabel: SKLabelNode?
    var streakBonusLabel: SKLabelNode?
    var levelLabel: SKLabelNode?
    var timeElapsedLabel: SKLabelNode?
    
    var elapsedTime: TimeInterval = 0.0
    var lastTimeStamp: TimeInterval = 0.0
    
    var ground: SKSpriteNode?
    var bgImage: SKSpriteNode?
    var gauge: SKSpriteNode?
    var gaugeFill: SKSpriteNode?
    var pauseButton: SKSpriteNode?
    var introLabel: SKSpriteNode?
    let introLabelTextures = [SKTexture(imageNamed: "popThoseDrops0"), SKTexture(imageNamed: "popThoseDrops1"), SKTexture(imageNamed: "popThoseDrops2")]
    
    // Game Variables
    var isCombo = false
    var lastDropXValue: CGFloat?
    var lastDropYValue: CGFloat?
    var startGameCalled = false
    
    // Physics World Categories
    let dropCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    
    override func didMove(to view: SKView) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appDidEnterForeground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        physicsWorld.contactDelegate = self
        
        if !(scene?.isPaused)! {
            bgImage = childNode(withName: "bgImage") as? SKSpriteNode
            bgImage?.texture = SKTexture(imageNamed: "background.pdf")
            bgImage?.zPosition = -1

            scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
            scoreLabel?.alpha = 0
            scoreLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (scoreLabel?.position)!)
            scoreLabel?.position = Utilities().shiftDown(view: view, currentPosition: (scoreLabel?.position)!)
            
            timeElapsedLabel = childNode(withName: "timeElapsedLabel") as? SKLabelNode
            timeElapsedLabel?.isHidden = true
            timeElapsedLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (timeElapsedLabel?.position)!)
            timeElapsedLabel?.position = Utilities().shiftDown(view: view, currentPosition: (timeElapsedLabel?.position)!)
            
            streakLabel = childNode(withName: "streakLabel") as? SKLabelNode
            streakLabel?.position = Utilities().shiftDown(view: view, currentPosition: (streakLabel?.position)!)
            
            levelTrackerLabel = childNode(withName: "levelTrackerLabel") as? SKLabelNode
            levelTrackerLabel?.alpha = 0
            levelTrackerLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (levelTrackerLabel?.position)!)
            levelTrackerLabel?.position = Utilities().shiftUp(view: view, currentPosition: (levelTrackerLabel?.position)!)
            
            multipleTrackerLabel = childNode(withName: "multipleTrackerLabel") as? SKLabelNode
            multipleTrackerLabel?.alpha = 0
            multipleTrackerLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (multipleTrackerLabel?.position)!)
            multipleTrackerLabel?.position = Utilities().shiftUp(view: view, currentPosition: (multipleTrackerLabel?.position)!)
            
            levelTrackerBackground = childNode(withName: "levelTrackerBackground") as? SKSpriteNode
            levelTrackerBackground?.alpha = 0
            levelTrackerBackground?.position = Utilities().shiftHorizontal(view: view, currentPosition: (levelTrackerBackground?.position)!)
            levelTrackerBackground?.position = Utilities().shiftUp(view: view, currentPosition: (levelTrackerBackground?.position)!)
            
            multipleTrackerBackground = childNode(withName: "multipleTrackerBackground") as? SKSpriteNode
            multipleTrackerBackground?.alpha = 0
            multipleTrackerBackground?.position = Utilities().shiftHorizontal(view: view, currentPosition: (multipleTrackerBackground?.position)!)
            multipleTrackerBackground?.position = Utilities().shiftUp(view: view, currentPosition: (multipleTrackerBackground?.position)!)
            
            missMeterTrackerBackground = childNode(withName: "missMeterTrackerBackground") as? SKSpriteNode
            missMeterTrackerBackground?.alpha = 0
            missMeterTrackerBackground?.position = Utilities().shiftHorizontal(view: view, currentPosition: (missMeterTrackerBackground?.position)!)
            missMeterTrackerBackground?.position = Utilities().shiftUp(view: view, currentPosition: (missMeterTrackerBackground?.position)!)
            
            missLabel = childNode(withName: "missLabel") as? SKLabelNode
            missLabel?.alpha = 0
            missLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (missLabel?.position)!)
            missLabel?.position = Utilities().shiftUp(view: view, currentPosition: (missLabel?.position)!)
            
            missesLeftLabel = childNode(withName: "missesLeftLabel") as? SKLabelNode
            missesLeftLabel?.isHidden = true
            missesLeftLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (missesLeftLabel?.position)!)
            missesLeftLabel?.position = Utilities().shiftUp(view: view, currentPosition: (missesLeftLabel?.position)!)
            
            streakBonusLabel = childNode(withName: "streakBonusLabel") as? SKLabelNode
            streakBonusLabel?.isHidden = true
            streakBonusLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (streakBonusLabel?.position)!)
            streakBonusLabel?.position = Utilities().shiftUp(view: view, currentPosition: (streakBonusLabel?.position)!)
            
            levelLabel = childNode(withName: "levelLabel") as? SKLabelNode
            levelLabel?.isHidden = true
            levelLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (levelLabel?.position)!)
            levelLabel?.position = Utilities().shiftUp(view: view, currentPosition: (levelLabel?.position)!)
            
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
            
            introAnimation()
        }
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
            self.levelTrackerBackground?.alpha = 1
            self.multipleTrackerBackground?.alpha = 1
            self.missMeterTrackerBackground?.alpha = 1

            self.levelTrackerLabel?.alpha = 1
            self.multipleTrackerLabel?.alpha = 1
            self.startGame()
            self.startGameCalled = true
        }
    }
    
    func startGame() {
        GameVariables().resetGameVariables()
        setGameState()
        GameVariables.gameIsActive = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name {
                switch name {
                case "drop":
                    if var drop = touchedNode as? Drop {
                        if drop.type != "levelDrop" {
                            drop = determineStreak(drop: drop)
                        } else {
                            GameVariables().levelUp(scene: self)
                            self.levelTrackerLabel?.text = String(GameVariables.currentLevel)
                        }
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
        self.levelTrackerLabel?.text = String(GameVariables.currentLevel)
        self.multipleTrackerLabel?.text = "\(GameVariables.multiplier)x"
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
        self.multipleTrackerLabel?.text = "\(GameVariables.multiplier)x"
        if GameVariables.firstDrop == true {
            GameVariables.firstDrop = false
        }
        return drop
    }
    
    func computeScore(drop: Drop) -> Drop {
        var newPoints = Int()
        
        if drop.type != "levelDrop" {
            if isCombo {
                newPoints = GameVariables.comboPoints * GameVariables.multiplier
            } else {
                newPoints = GameVariables.singleLetterPoints * GameVariables.multiplier
            }
        } else {
            newPoints = GameVariables.singleLetterPoints * 10
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
        var drop = Drop(isLevelDrop: false)
        if timeToCreateLevelDrop {
            drop = Drop(isLevelDrop: true)
            self.timeToCreateLevelDrop = false
        }
        
        drop.name = "drop"
        drop.physicsBody = SKPhysicsBody(rectangleOf: drop.size)
        drop.physicsBody?.affectedByGravity = false
        drop.zPosition = 10
        
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = groundCategory
        drop.physicsBody?.collisionBitMask = 0
        
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
        
        let moveDown = SKAction.moveBy(x: 0, y: -size.height - drop.size.height, duration: GameControls.initialDropDuration)
        drop.speed = GameVariables.dropSpeed
        drop.run(moveDown)
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
        print("gameOver called")
        
        self.missLabel?.text = "0"
        self.levelTrackerLabel?.text = "1"
        self.multipleTrackerLabel?.text = "1x"
        
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
                GameVariables.gameIsActive = false
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
                    levelLabel.fontColor = UIColor.StyleFile.Orange
                    levelLabel.fontName = "Righteous-Regular"
                    levelLabel.fontSize = 48
                    levelLabel.text = "Level \(GameVariables.currentLevel)"
                    let levelLabely = y + 60
                    
                    levelLabel.position = CGPoint(x: dropToScore.position.x, y: levelLabely)
                    let fadeAction = SKAction.fadeOut(withDuration: 1)
                    let moveAction = SKAction.moveBy(x: 20, y: 20, duration: 1)
                    self.addChild(levelLabel)
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
        self.addChild(dropScoreLabel)
        dropScoreLabel.run(moveAction)
        dropScoreLabel.run(fadeAction) {
            dropScoreLabel.removeFromParent()
        }
    }
    
    func pauseGame() {
        introLabel?.alpha = 0
        lastTimeStamp = 0.0
        if let sceneCheck = scene {
            scene?.isPaused = true
            print("sceneCheck.isPaused: \(sceneCheck.isPaused)")
            for child in sceneCheck.children {
                if let name = child.name {
                    switch name {
                    case "pauseButton","drop","streakLabel":
                        child.isHidden = true
                    case "pauseLabel","playButton","settingsButton","quitButton":
                        child.isHidden = false
                    case "missesLeftLabel","streakBonusLabel","levelLabel","timeElapsedLabel":
                        if self.elapsedTime > 0 {
                            let formatter = DateComponentsFormatter()
                            formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
                            formatter.allowedUnits = [ .hour, .minute, .second ]
                            if let formattedDuration = formatter.string(from: elapsedTime) {
                                if elapsedTime > 60 {
                                    timeElapsedLabel?.text = "Time: \(formattedDuration)"
                                } else {
                                    timeElapsedLabel?.text = "Time: \(formattedDuration) Seconds"
                                }
                            }
                            
                            
                            child.isHidden = false
                        }
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
                    case "pauseButton","drop","streakLabel":
                        child.isHidden = false
                    case "pauseLabel","playButton","settingsButton","quitButton":
                        child.isHidden = true
                    case "missesLeftLabel","streakBonusLabel","levelLabel","timeElapsedLabel":
                        if self.elapsedTime > 0 {
                            child.isHidden = true
                        }
                    default:
                        print("default in resumeGame called")
                    }
                }
            }
        }
        
        if startGameCalled {
            print("start game called")
        } else {
            introLabel?.alpha = 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if startGameCalled {
            var difference = TimeInterval()
            if lastTimeStamp != 0.0 {
                difference = currentTime - lastTimeStamp
            }
            
            elapsedTime += difference
            timeToLevelUp += difference
            lastTimeStamp = currentTime
            
            // Create Drops
            if timeToDrop == 0 {
                timeToDrop = currentTime
            } else if currentTime - timeToDrop > GameVariables.dropFrequency {
                createDrop()
                timeToDrop = currentTime
            }
            
            if self.timeToLevelUp > GameControls.levelUpFrequency {
                timeToLevelUp = 0
                timeToCreateLevelDrop = true
            }
        }
        
        // Create Rain
        if timeToRain == 0 {
            timeToRain = currentTime
        } else if currentTime - timeToRain > GameControls.rainFrequency {
            createSmallDrop(speed: GameControls.rainSpeed)
            timeToRain = currentTime
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == dropCategory {
            if let drop = contact.bodyB.node as? Drop {
                updateMissMeter(changeValue: -2)
                drop.missPoints = -2
                animateSplash(dropToSplash: drop)
                animateDropScore(dropToScore: drop)
            }
        }
        if contact.bodyB.categoryBitMask == dropCategory {
            if var drop = contact.bodyB.node as? Drop {

                if drop.type == "levelDrop" {
                    drop = GameVariables().updateMissedLevelDrop(drop: drop)
                    updateMissMeter(changeValue: drop.missPoints!)
                } else {
                    updateMissMeter(changeValue: -2)
                    drop.missPoints = -2
                }

                animateSplash(dropToSplash: drop)
                animateDropScore(dropToScore: drop)
//                gameOver()
            }
        }
    }
    
    @objc func appMovedToBackground() {
        if GameVariables.gameIsActive {
            pauseGame()
        }
    }
    
    @objc func appDidEnterForeground() {
        if GameVariables.gameIsActive {
            pauseGame()
        }
    }
}
