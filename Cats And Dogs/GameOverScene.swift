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
    
//    let gameOver = SKLabelNode(fontNamed: "arial")
    // let submitScore = SKSpriteNode(imageNamed: "button")
    let submitScoreText = SKLabelNode(fontNamed: "arial")
    let submitScoreTextShadow = SKLabelNode(fontNamed: "arial")
    var nameTextField: UITextField!
    
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
        createNameTextField()
        saveScore()
    }
    
    func saveScore() {
        let score = HighScore()
        score.playerName = "Levi"
        score.score = GameVariables.score
        score.timestamp = Date()
        HighScores.highScores.append(score)
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
    
    func createNameTextField() {
        let frame = CGRect(x: (view?.bounds.width)! / 2 - 160, y: (view?.bounds.height)! / 2 - 20, width: 320, height: 40)
        
        nameTextField = UITextField(frame: frame)
        
        // add the UITextField to the GameScene's view
        view?.addSubview(nameTextField)
        
        // Add the gamescene as the UITextField delegate.
        // delegate funtion called is textFieldShouldReturn:
        nameTextField.delegate = self
        
        nameTextField.borderStyle = UITextBorderStyle.none
        nameTextField.tintColor = UIColor.StyleFile.LightBlueGray
        nameTextField.textColor = UIColor.StyleFile.DarkBlueGray
        nameTextField.text = "Levi"
        nameTextField.textColor = UIColor.StyleFile.LightBlueGray
        nameTextField.textAlignment = .center
        nameTextField.font = UIFont.StyleFile.textFieldFont
        nameTextField.returnKeyType = .continue
        nameTextField.backgroundColor = UIColor.clear
        nameTextField.autocorrectionType = .no
        nameTextField.keyboardAppearance = .dark
        
        nameTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        nameTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        self.view!.addSubview(nameTextField)
    }


    // Called by tapping return on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Populates the SKLabelNode
        if let text = nameTextField.text {
            print("text: \(text)")
        }
        
        // Hides the keyboard
        nameTextField.resignFirstResponder()
        return true
    }
    
    override func willMove(from view: SKView) {
        nameTextField.removeFromSuperview()
    }
}
