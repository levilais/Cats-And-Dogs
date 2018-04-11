//
//  GameOverScene.swift
//  Cats And Dogs
//
//  Created by Levi on 2/28/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var bgImage: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        bgImage = childNode(withName: "bgImage") as? SKSpriteNode
        bgImage?.texture = SKTexture(imageNamed: "background.pdf")
        bgImage?.zPosition = -1
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: GameVariables.score as! NSNumber) {
            scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
            if let scoreLabelCheck = scoreLabel {
                scoreLabelCheck.text = String(formattedNumber)
            }
        }
        saveScore()
    }
    
    func saveScore() {
        let score = HighScore(score: GameVariables.score, playerName: "Levi", timestamp: Date())
        UserDefaultsHelper().saveScoreToUserDefaults(newScoreToSave: score)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name {
                switch name {
                case "playButton":
                    if let view = self.view as! SKView? {
                        if let gameScene = SKScene(fileNamed: "GameScene") {
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
}
