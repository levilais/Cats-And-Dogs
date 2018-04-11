//
//  GameOverScene.swift
//  Cats And Dogs
//
//  Created by Levi on 2/28/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class GameOverScene: SKScene, UITextFieldDelegate {
    
    var bgImage: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var submitButton: SKSpriteNode?
    var yourScoreLabel: SKLabelNode?
    var gameOverLabel: SKLabelNode?
    var textFieldPlacementNode: SKSpriteNode?
    var nameLabel: SKLabelNode?
    var scoreRankText: String?
    var scoreRank = Int()

    let submitScoreText = SKLabelNode(fontNamed: "arial")
    let submitScoreTextShadow = SKLabelNode(fontNamed: "arial")
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector: #selector(lastNameChangedSetLabel), name: NSNotification.Name(rawValue: "lastNameUsedChanged"), object: nil)
        
        GameAudio().soundThunderStrike(scene: self)
        
        bgImage = childNode(withName: "bgImage") as? SKSpriteNode
        bgImage?.texture = SKTexture(imageNamed: "background.pdf")
        bgImage?.zPosition = -1
        
        submitButton = childNode(withName: "submitButton") as? SKSpriteNode
        textFieldPlacementNode = childNode(withName: "textFieldPlacementNode") as? SKSpriteNode
        yourScoreLabel = childNode(withName: "yourScoreLabel") as? SKLabelNode
        gameOverLabel = childNode(withName: "gameOverLabel") as? SKLabelNode
        nameLabel = childNode(withName: "nameLabel") as? SKLabelNode
        nameLabel?.text = GameVariables.lastNameUsed
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: GameVariables.score as NSNumber) {
            scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
            if let scoreLabelCheck = scoreLabel {
                scoreLabelCheck.text = String(formattedNumber)
            }
        }
        getScoreRank()
        saveScore()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentCustomPopup"), object: nil)
    }
    
    func getScoreRank() {
        if HighScoresClass.highScores.count == 0 {
            self.scoreRank = 0
            self.scoreRankText = "Now THAT'S a score to beat!"
        } else {
            var i = 0
            var scoreRankFound = false
            var lastScore = Int()
            var matchesHighScore = false
            while scoreRankFound == false {
                if GameVariables.score >= HighScoresClass.highScores[i].score {
                    if lastScore == GameVariables.score {
                        matchesHighScore = true
                    }
                    scoreRankFound = true
                } else {
                    lastScore = HighScoresClass.highScores[i].score
                    i += 1
                }
                if i == HighScoresClass.highScores.count {
                    scoreRankFound = true
                }
            }
            
            scoreRank = i
            
            if scoreRank != 0 {
                if self.scoreRank == HighScoresClass.highScores.count {
                    self.scoreRankText = "Eek...your worst score yet!"
                } else {
                    let formattedNumber = NumberFormatter.localizedString(from: NSNumber(value: (i + 1)), number: .ordinal)
                    self.scoreRankText = "Congrats on your \(formattedNumber) best score!"
                }
            } else {
                if matchesHighScore {
                    self.scoreRankText = "You tied your high score!"
                } else {
                    self.scoreRankText = "A new high score!"
                }
            }
        }
        if let scoreRankTextCheck = scoreRankText {
            yourScoreLabel?.text = scoreRankTextCheck
        }
    }
    
    func saveScore() {
        print("most misses while still hitting one hundred at GameOver: \(GameVariables.mostMissesWithOneHundredHit)")
        
        let score = HighScore()
        if GameVariables.lastNameUsed != "Tap Here To Sign" {
            score.playerName = GameVariables.lastNameUsed
        } else {
            score.playerName = "Unsigned"
        }
        
        score.identifier = UUID().uuidString
        score.score = GameVariables.score
        score.timestamp = Date()
        score.level = GameVariables.currentLevel
        score.skippedLevelUps = GameVariables.skippedLevelUps
        score.longestStreak = GameVariables.longestStreak
        score.bestDrop = GameVariables.bestDrop
        score.poppedDrops = GameVariables.poppedDrops
        score.missedDrops = GameVariables.missedDrops
        score.accuracy = GameVariables.accuracy
        score.combos = GameVariables.combos
        score.time = GameVariables.time
        
        GameVariables.gameOverHighScore = score
        CoreDataHelper().saveHighScore(highScore: score)
        
        let newAchievements = UserAchievementsObject().determineNewUserAchievements(score: score)
        UserAchievementsHelper().updateUserAchievements(newUserAchievements: newAchievements)
        
        
        // NOTICE - figure out how to add "Silver Level Unlocked" and "Gold Level Unlocked" achievement notificaitons when doing the notifications.
        
        
//        if UserPrefs.achievementLevelUpTriggered {
//            UserPrefs.achievementLevelUpTriggered = false
//            let newAchievementsRoundTwo = UserAchievementsObject().determineNewUserAchievements(score: score)
//            UserAchievementsHelper().updateUserAchievements(newUserAchievements: newAchievementsRoundTwo)
//        }
    }
    
    @objc func lastNameChangedSetLabel() {
        nameLabel?.text = GameVariables.lastNameUsed
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name {
                switch name {
                case "submitButton":
                    if let view = self.view as! SKView? {
                        if let gameScene = SKScene(fileNamed: "GameScene") {
                            gameScene.scaleMode = .aspectFill
                            view.presentScene(gameScene)
                        }
                    }
                case "quitButton":
                    if let view = self.view as! SKView? {
                        if let gameScene = SKScene(fileNamed: "HomeScene") {
                            gameScene.scaleMode = .aspectFill
                            view.presentScene(gameScene)
                        }
                    }
                case "statsButton":
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentStatsViewController"), object: nil)
                case "nameLabel":
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showEnterNameViewController"), object: nil)
                default:
                    print("no button touched")
                }
            }
        }
    }
}
