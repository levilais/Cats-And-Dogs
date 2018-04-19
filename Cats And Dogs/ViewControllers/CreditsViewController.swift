//
//  CreditsViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 4/19/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit


class CreditsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func doneButtonDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
