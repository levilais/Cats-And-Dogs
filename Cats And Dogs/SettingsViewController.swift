//
//  SettingsViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 3/3/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goBackDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
