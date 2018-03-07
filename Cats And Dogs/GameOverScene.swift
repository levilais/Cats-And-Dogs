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
    var nameTextField: UITextField!
    
    override func didMove(to view: SKView) {
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
        
        createNameTextField()
    }
    
    func saveScore() {
        let score = HighScore()
        
        if let nameText = nameTextField.text {
            let formattedText = nameText.trimmingCharacters(in: .whitespaces)
            score.playerName = formattedText
            GameVariables.lastNameUsed = formattedText
        }
        
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
                case "submitButton":
                    saveScore()
                    if let view = self.view as! SKView? {
                        if let gameScene = SKScene(fileNamed: "GameScene") {
                            gameScene.scaleMode = .aspectFill
                            view.presentScene(gameScene)
                        }
                    }
                case "nameLabel":
                    nameTextField.becomeFirstResponder()
                    scoreLabel?.isHidden = true
                    gameOverLabel?.isHidden = true
                    submitButton?.isHidden = true
                    yourScoreLabel?.isHidden = true
                    nameLabel?.isHidden = true
                    nameTextField.isHidden = false
                default:
                    print("no button touched")
                }
            }
        }
    }
    
    
    func createNameTextField() {
        let width = (view?.bounds.width)! - 60
        let textFieldFrame = CGRect(x: (view?.bounds.width)! / 2 - width / 2, y: (view?.bounds.height)! / 2, width: width, height: 60)
        
        nameTextField = UITextField(frame: textFieldFrame)
        
        // add the UITextField to the GameScene's view
        view?.addSubview(nameTextField)
        
        nameTextField.delegate = self
        
        nameTextField.textColor = UIColor.StyleFile.LightBlueGray
        nameTextField.text = GameVariables.lastNameUsed
        nameTextField.textAlignment = .center
        nameTextField.font = UIFont.StyleFile.textFieldFont
        nameTextField.returnKeyType = .continue
        nameTextField.backgroundColor = UIColor.clear
        nameTextField.autocorrectionType = .no
        nameTextField.keyboardAppearance = .dark
        nameTextField.keyboardType = .asciiCapable
        
        nameTextField.tintColor = UIColor.StyleFile.LightBlueGray
        nameTextField.borderStyle = UITextBorderStyle.none
        nameTextField.layer.borderColor = UIColor.StyleFile.LightBlueGray.cgColor
        nameTextField.layer.borderWidth = 1.0
        
        nameTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        self.view!.addSubview(nameTextField)
        nameTextField.isHidden = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if text == "Tap Here To Sign" {
                textField.text = ""
            }
        }
        return true
    }

    // Called by tapping return on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Populates the SKLabelNode
        if let text = nameTextField.text {
            print("text: \(text)")
            nameLabel?.text = text
            GameVariables.lastNameUsed = text
        }
        
        nameTextField.isHidden = true
        nameTextField.becomeFirstResponder()
        scoreLabel?.isHidden = false
        gameOverLabel?.isHidden = false
        submitButton?.isHidden = false
        yourScoreLabel?.isHidden = false
        nameLabel?.isHidden = false
        
        // Hides the keyboard
        nameTextField.resignFirstResponder()
        return true
    }
    
    override func willMove(from view: SKView) {
        nameTextField.removeFromSuperview()
    }
}
