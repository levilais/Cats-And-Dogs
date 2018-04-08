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
    @IBOutlet weak var bronzeToggle: UIButton!
    @IBOutlet weak var silverToggle: UIButton!
    @IBOutlet weak var goldToggle: UIButton!
    
    @IBOutlet var achievementButtons: [UIButton]!
    @IBOutlet var achievementLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        backgroundBottomLayout.constant -= (self.view.safeAreaInsets.bottom)
    }
    
    @IBAction func achievementButtonDidPress(_ sender: Any) {
        let button = sender as! UIButton
        print("\(button.tag) button")
    }
    
    @IBAction func bronzeToggleDidPress(_ sender: Any) {
        print("bronze toggle pressed")
    }
    
    @IBAction func silverToggleDidPress(_ sender: Any) {
        print("silver toggle pressed")
    }
    
    @IBAction func goldToggleDidPress(_ sender: Any) {
        print("gold toggle pressed")
    }
    
    @IBAction func xButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
