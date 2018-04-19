//
//  PopUpViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 4/8/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var popupBackground: UIView!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var howToLabel: UILabel!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func displayViewButtonDidPress(_ sender: Any) {
    }
    
    @IBAction func dismissDidPress(_ sender: Any) {
        print("dismiss did press")
        Utilities().dismissViewController(viewController: self)
    }
}
