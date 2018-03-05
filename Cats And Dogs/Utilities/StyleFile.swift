//
//  StyleFile.swift
//  Cats And Dogs
//
//  Created by Levi on 3/5/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    struct StyleFile {
        static let DarkBlueGray = UIColor(red:0.25, green:0.29, blue:0.33, alpha:1.0)
        static let LightBlueGray = UIColor(red:0.56, green:0.62, blue:0.69, alpha:1.0)
        static let WaterBlue = UIColor(red:0.67, green:0.77, blue:0.80, alpha:1.0)
        static let Tan = UIColor(red:0.82, green:0.76, blue:0.66, alpha:1.0)
        static let Salmon = UIColor(red:1.00, green:0.58, blue:0.55, alpha:1.0)
        static let ToggleSelectedColor = UIColor(red:0.41, green:0.46, blue:0.53, alpha:1.0)
    }
}

extension UIFont {
    struct StyleFile {
        static let latoBlack = UIFont(name: "Lato-Black", size: 20)
        static let latoLight = UIFont(name: "Lato-Light", size: 20)
        static let latoHariline = UIFont(name: "Lato-Hairline", size: 20)
        static let latoBold = UIFont(name: "Lato-Bold.ttf", size: 20)
        
    }
}
