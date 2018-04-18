//
//  TutorialViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 4/16/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var backgroundLayoutConstraint: NSLayoutConstraint!
    
    var slideShowing = 0
    var viewLayedOutSubviews = false

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay()
        if !UserPrefs.tutorialHasBeenShown {
            UserPrefs().saveTutorialAsShown()
        }
    }
    
    override func viewWillLayoutSubviews() {
        if !viewLayedOutSubviews {
            backgroundLayoutConstraint.constant -= (self.view.safeAreaInsets.bottom)
            viewLayedOutSubviews = true
        }
    }
    
    func showNext() {
        if slideShowing < 4 {
            slideShowing += 1
            updateDisplay()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func exitTutorial() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateDisplay() {
        instructionLabel.text = TutorialHelper.instructions[slideShowing]
        image.image = UIImage(named: "tutorial\(slideShowing)")
    }
    
    @IBAction func submitButtonDidPress(_ sender: Any) {
        showNext()
    }
    
    @IBAction func skipTutorialButtonDidPress(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
