//
//  AchievementsViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 4/7/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {

    @IBOutlet weak var backgroundBottomLayout: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        backgroundBottomLayout.constant -= (self.view.safeAreaInsets.bottom)

    }

    @IBAction func xButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
