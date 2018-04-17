//
//  TutorialViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 4/16/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var tutorialCounterImages: [UIImageView]!
    
    @IBOutlet weak var backgroundLayoutConstraint: NSLayoutConstraint!
    
    var slideShowing = 0
    var viewLayedOutSubviews = false

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay()
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
            print("done with tutorial")
        }
    }
    
    func updateDisplay() {
        instructionLabel.text = TutorialHelper.instructions[slideShowing]
        image.image = UIImage(named: "tutorial\(slideShowing)")
        var i = 0
        for image in tutorialCounterImages {
            if i != slideShowing {
                image.alpha = 0.5
            } else {
                image.alpha = 1.0
            }
            i += 1
        }
    }
    
    @IBAction func submitButtonDidPress(_ sender: Any) {
        showNext()
    }
    
    @IBAction func skipTutorialButtonDidPress(_ sender: Any) {
        print("skip tutorial pressed")
//        dismiss(animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
