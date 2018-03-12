//
//  GameOverScene.swift
//  Cats And Dogs
//
//  Created by Levi on 2/28/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene, UITextFieldDelegate {
    
    var bgImage: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var submitButton: SKSpriteNode?
    var yourScoreLabel: SKLabelNode?
    var gameOverLabel: SKLabelNode?
    var textFieldPlacementNode: SKSpriteNode?
    var nameLabel: SKLabelNode?

    let submitScoreText = SKLabelNode(fontNamed: "arial")
    let submitScoreTextShadow = SKLabelNode(fontNamed: "arial")
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector: #selector(lastNameChangedSetLabel), name: NSNotification.Name(rawValue: "lastNameUsedChanged"), object: nil)
        
//        GameVariables.gameIsActive = false
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
        if let formattedNumber = numberFormatter.string(from: GameVariables.score as! NSNumber) {
            scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
            if let scoreLabelCheck = scoreLabel {
                scoreLabelCheck.text = String(formattedNumber)
            }
        }
    }
    
    func saveScore() {
        let score = HighScore()
        score.playerName = GameVariables.lastNameUsed
        score.score = GameVariables.score
        score.timestamp = Date()
        
        if HighScores.highScores.count == 0 {
            HighScores.highScores.append(score)
        } else {
            var i = 0
            var scoreRankFound = false
            while scoreRankFound == false {
                let existingScores = HighScores.highScores
                let existingScore = existingScores[i]
                if let existingScoreCheck = existingScore.score {
                    if let scoreCheck = score.score {
                        if scoreCheck > existingScoreCheck {
                            print("new score: \(scoreCheck), existingScore: \(existingScoreCheck)")
                            HighScores.highScores.insert(score, at: i)
                            scoreRankFound = true
                        }
                    }
                i += 1
                }
                HighScores.highScores.append(score)
                scoreRankFound = true
            }
        }
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
                    saveScore()
                    if let view = self.view as! SKView? {
                        if let gameScene = SKScene(fileNamed: "GameScene") {
                            gameScene.scaleMode = .aspectFill
                            view.presentScene(gameScene)
                        }
                    }
                case "nameLabel":
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showEnterNameViewController"), object: nil)
                default:
                    print("no button touched")
                }
            }
        }
    }
}
