//
//  QuitConfirmationPopupViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 4/18/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class QuitConfirmationPopupViewController: UIViewController {
    
    @IBOutlet weak var popupBackground: UIView!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.borderColor = UIColor.StyleFile.Tan.cgColor
        cancelButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.StyleFile.Tan.cgColor
        confirmButton.layer.borderWidth = 1
    }
    
    @IBAction func cancelDidPress(_ sender: Any) {
        Utilities().dismissViewController(viewController: self)
    }
    
    @IBAction func continueButtonDidPress(_ sender: Any) {
        Utilities().dismissViewController(viewController: self)
        if let vc = self.parent as? GameViewController {
            vc.quitWasConfirmed = true
        }
    }
}
