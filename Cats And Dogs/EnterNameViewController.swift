//
//  EnterNameViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 3/12/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class EnterNameViewController: UIViewController, UITextFieldDelegate {
    
    var highScoreToUpdateNameOn = HighScore()
    var viewInitiallyLoaded = false

    @IBOutlet weak var backgroundBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNameTextField()
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        if !viewInitiallyLoaded {
            backgroundBottomLayout.constant -= (self.view.safeAreaInsets.bottom)
            viewInitiallyLoaded = true
        }
    }

    @IBAction func xButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func styleNameTextField() {
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
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if text == "Tap Here To Sign" {
                textField.text = ""
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var newHighScore = GameVariables.gameOverHighScore
        if let text = nameTextField.text {
            if text != "" {
                let formattedText = text.trimmingCharacters(in: .whitespaces)
                GameVariables.lastNameUsed = formattedText
                newHighScore?.playerName = GameVariables.lastNameUsed
                
            } else {
                GameVariables.lastNameUsed = "Tap Here To Sign"
                newHighScore?.playerName = "Unsigned"
            }
            CoreDataHelper().updateName(highScore: self.highScoreToUpdateNameOn, newName: GameVariables.lastNameUsed)
            GameVariables.gameOverHighScore = newHighScore
        }
        
        nameTextField.resignFirstResponder()
        self.dismiss(animated: true)
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
