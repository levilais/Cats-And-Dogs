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
    var water: SKSpriteNode?
    
    var elapsedTime: TimeInterval = 0.0
    var lastTimeStamp: TimeInterval = 0.0
    
    var introElapsedTime: TimeInterval = 0.0
    var introLastTimeStamp: TimeInterval = 0.0
    var timeToSoundDrum = 0.0
    var drumSoundCount = 0
    var introTimerRunning = true
    
    var ground: SKSpriteNode?
    var bgImage: SKSpriteNode?
    var gauge: SKSpriteNode?
    var gaugeFill: SKSpriteNode?
    var pauseButton: SKSpriteNode?
    var introLabel: SKSpriteNode?
    let introLabelTextures = [SKTexture(imageNamed: "popThoseDrops0"), SKTexture(imageNamed: "popThoseDrops1"), SKTexture(imageNamed: "popThoseDrops2")]
    
    // Game Variables
    var startGameCalled = false
    
    // Physics World Categories
    let dropCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    
    override func didMove(to view: SKView) {
        if let drums = GameAudio.drumsAudioPlayer {
            drums.setVolume(0.0, fadeDuration: 0.1)
        }
    
        let notificationCenter = NotificationCenter.default
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
            streakLabel?.position = Utilities().shiftHorizontal(view: view, currentPosition: (streakLabel?.position)!)
            streakLabel?.text = ""
            
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
            ground?.position = Utilities().shiftUp(view: view, currentPosition: (ground?.position)!)
            
            water = childNode(withName: "water") as? SKSpriteNode
            water?.position = Utilities().shiftUp(view: view, currentPosition: (water?.position)!)
            water?.zPosition = 25
            
            pauseButton = childNode(withName: "pauseButton") as? SKSpriteNode
            pauseButton?.name = "pauseButton"
            pauseButton?.zPosition = .infinity
            pauseButton?.position = Utilities().shiftHorizontal(view: view, currentPosition: (pauseButton?.position)!)
            pauseButton?.position = Utilities().shiftDown(view: view, currentPosition: (pauseButton?.position)!)
            Utilities().resizespriteNode(spriteNode: pauseButton!, view: view)
            
            scene?.childNode(withName: "playButton")?.isHidden = true
            scene?.childNode(withName: "quitButton")?.isHidden = true
            scene?.childNode(withName: "settingsButton")?.isHidden = true
            scene?.childNode(withName: "pauseLabel")?.isHidden = true

            if let rainAudioPlayer = GameAudio.rainAudioPlayer {
                rainAudioPlayer.setVolume(0.5, fadeDuration: 2.0)
            }
            introAnimation()
        }
    }
    
    func introAnimation() {
        self.introLabel = SKSpriteNode(texture: self.introLabelTextures[0])
        self.introLabel?.position = CGPoint(x: 0, y: frame.height / 4)
        self.introLabel?.alpha = 0
        scene?.addChild(self.introLabel!)

        let wait = SKAction.wait(forDuration: 1)
        let show = SKAction.fadeIn(withDuration: 0.0)
        let animateImageChange = SKAction.animate(with: self.introLabelTextures, timePerFrame: 1)
        let sequence = SKAction.sequence([wait, show, animateImageChange])
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
        GameVariables.gameIsActive = true
        if GameAudio.backgroundMusicPlayer == nil {
            GameAudio().playBackgroundMusic()
        } else {
            GameAudio().resetBackgroundMusic()
        }
        GameVariables().resetGameVariables()
        setGameState()
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
                            GameVariables.poppedDrops += 1
                            drop = determineStreak(drop: drop)
                        } else {
                            GameVariables().levelUp(scene: self)
                            self.levelTrackerLabel?.text = String(GameVariables.currentLevel)
                            GameAudio().soundPopAndChime(scene: self)
                        }
                        
                        
//                        GameAudio().soundPop()
                        
                        
                        drop = DropFunctions().computeScore(drop: drop)
                        UserAchievementsObject().checkForMillionInMinutes(elapsedTime: elapsedTime)
                        updateScoreLabel()
                        
//                        if drop.isComboDrop {
//                            GameAudio().soundPopAndShake(scene: self)
//                        } else {
//                            GameAudio().soundPop(scene: self)
//                        }
                        
                        DropFunctions().animateSplash(dropToSplash: drop, scene: self)
                        DropFunctions().animateDropScore(dropToScore: drop, scene: self)
                    }
                case "pauseButton":
                    pauseGame()
                case "playButton":
                    resumeGame()
                case "quitButton":
                    print("show notification")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentConfirmationViewController"), object: nil)
                case "settingsButton":
                    print("settings button pressed")
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
        let determinedDrop = DropFunctions().determineStreak(drop: drop, scene: self)
        
        if let missPoints = drop.missPoints {
            updateMissMeter(changeValue: missPoints)
        }
        
        if let string = drop.streakString {
            streakLabel?.text = string
        }
        
        self.multipleTrackerLabel?.text = "\(GameVariables.multiplier)x"
        
        if GameVariables.firstDrop == true {
            GameVariables.firstDrop = false
        }
        
        return determinedDrop
    }
    
    func createDrop() {
        var drop = Drop()
        drop = drop.createLetterDrop(drop: drop)
        if timeToCreateLevelDrop {
            drop = Drop().createLevelDrop(drop: drop)
            self.timeToCreateLevelDrop = false
        }
        
        drop.physicsBody?.categoryBitMask = dropCategory
        drop.physicsBody?.contactTestBitMask = groundCategory
        drop.physicsBody?.collisionBitMask = 0
        
        if let view = self.view {
            Utilities().resizespriteNode(spriteNode: drop, view: view)
        }
        
        addChild(drop)
        DropFunctions().moveDrop(drop: drop, scene: self, view: self.view!)
    }
    
    func updateScoreLabel() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value:GameVariables.score)) {
            scoreLabel?.text = formattedNumber
        }
    }
    
    func updateMissMeter(changeValue: Int) {
        var valueToChange = changeValue
        var isGameOver = false
        
        if abs(changeValue) >= GameVariables.missesLeft {
            if changeValue != 5 {
                isGameOver = true
            }
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
            GameVariables().determineZeroToOneHundred()
            
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
        if let backgroundMusicPlayer = GameAudio.backgroundMusicPlayer {
            backgroundMusicPlayer.setVolume(0.0, fadeDuration: 2.0)
        }
        
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
        
        GameVariables.time = elapsedTime
        
        if let view = self.view {
            if let gameOverScene = SKScene(fileNamed: "GameOverScene") {
                GameVariables.gameIsActive = false
                gameOverScene.scaleMode = .aspectFill
                view.presentScene(gameOverScene)
            }
        }
    }
    
    func pauseGame() {
        if let backgroundMusicPlayer = GameAudio.backgroundMusicPlayer {
            print("fading audio out")
            backgroundMusicPlayer.setVolume(0.4, fadeDuration: 1.0)
        }
        introLabel?.alpha = 0
        lastTimeStamp = 0.0
        if let sceneCheck = scene {
            scene?.isPaused = true
            for child in sceneCheck.children {
                if let name = child.name {
                    switch name {
                    case "pauseButton","drop","streakLabel","dropScoreLabel", "missMeterPointChangeLabel":
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
        if let backgroundMusicPlayer = GameAudio.backgroundMusicPlayer {
            print("fading audio in")
            if UserPrefs.musicAllowed {
                if backgroundMusicPlayer.isPlaying {
                    backgroundMusicPlayer.setVolume(1.0, fadeDuration: 1.0)
                }
            }
        }
        if let sceneCheck = scene {
            sceneCheck.isPaused = false
            for child in sceneCheck.children {
                if let name = child.name {
                    switch name {
                    case "pauseButton","drop","streakLabel","dropScoreLabel", "missMeterPointChangeLabel":
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
        if UserPrefs.musicAllowed {
            if introTimerRunning == true {
                var difference = TimeInterval()
                if introLastTimeStamp != 0.0 {
                    difference = currentTime - introLastTimeStamp
                }
                
                introElapsedTime += difference
                introLastTimeStamp = currentTime
                print("introElapsedTime: \(introElapsedTime)")
                
                if timeToSoundDrum == 0 {
                    timeToSoundDrum = currentTime
                } else if currentTime - timeToSoundDrum > 1.0 {
                    if drumSoundCount < 4 {
                        let drumStrike = GameAudio().drumStrike()
                        run(drumStrike)
                        timeToSoundDrum = currentTime
                        drumSoundCount += 1
                        if GameAudio.drumsAudioPlayer != nil {
                            GameAudio().stopAndResetDrums()
                        }
                    } else {
                        introTimerRunning = false
                    }
                }
            }
        }
        
        if introTimerRunning == true {
            var difference = TimeInterval()
            if introLastTimeStamp != 0.0 {
                difference = currentTime - introLastTimeStamp
            }
            
            introElapsedTime += difference
            introLastTimeStamp = currentTime
            print("introElapsedTime: \(introElapsedTime)")
            
            if timeToSoundDrum == 0 {
                timeToSoundDrum = currentTime
            } else if currentTime - timeToSoundDrum > 1.0 {
                if drumSoundCount < 3 {
                    let drumStrike = GameAudio().drumStrike()
                    run(drumStrike)
                    timeToSoundDrum = currentTime
                    drumSoundCount += 1
                } else {
                    introTimerRunning = false
                }
            }
        }
        
        if startGameCalled {
            var difference = TimeInterval()
            if lastTimeStamp != 0.0 {
                difference = currentTime - lastTimeStamp
            }
            
            elapsedTime += difference
            timeToLevelUp += difference
            lastTimeStamp = currentTime
            
            if timeToDrop == 0 {
                timeToDrop = currentTime
            } else if currentTime - timeToDrop > GameVariables.dropFrequency {
                createDrop()
                timeToDrop = currentTime
            }
            
            if GameVariables.currentLevel < 10 {
                if self.timeToLevelUp > GameControls.levelUpFrequency {
                    timeToLevelUp = 0
                    timeToCreateLevelDrop = true
                }
            }
            
            if self.elapsedTime > GameEnvironment.timeForLightning && !GameEnvironment.timeForLightningTriggered {
                GameEnvironment.timeForLightningTriggered = true
                GameEnvironment().createLightningAnimation(backgroundImage: bgImage!, scene: self)
            }
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
                updateMissMeter(changeValue: -2)
                drop.missPoints = -2
                DropFunctions().animateSplash(dropToSplash: drop, scene: self)
                DropFunctions().animateDropScore(dropToScore: drop, scene: self)
            }
        }
        if contact.bodyB.categoryBitMask == dropCategory {
            if var drop = contact.bodyB.node as? Drop {
                if drop.type == "levelDrop" {
                    drop = GameVariables().updateMissedLevelDrop(drop: drop)
                    updateMissMeter(changeValue: drop.missPoints!)
                    GameVariables.skippedLevelUps += 1
                } else {
                    updateMissMeter(changeValue: -2)
                    drop.missPoints = -2
                    GameVariables.missedDrops += 1
                }
                DropFunctions().animateSplash(dropToSplash: drop, scene: self)
                DropFunctions().animateDropScore(dropToScore: drop, scene: self)

                // FOR TESTING: gameOver()
            }
        }
    }
    
    @objc func appDidEnterForeground() {
        pauseGame()
        if UserPrefs.rainAllowed {
            if (GameAudio.rainAudioPlayer?.isPlaying) != nil {
                
            }
        }
    }
}
