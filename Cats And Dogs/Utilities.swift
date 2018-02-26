//
//  Utilities.swift
//  Cats And Dogs
//
//  Created by Levi on 2/25/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import UIKit



public extension Float {
    // E.X. let randomNumFloat   = Float.random(min: 6.98, max: 923.09)
    func random(min: Float, max: Float) -> Float {
        return Float(arc4random()) / 0xFFFFFFFF * (max - min) + min
    }
}

public extension CGFloat {
    //  E.X. let randomNumCGFloat = CGFloat.random(min: 6.98, max: 923.09)
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        let randomNumber: CGFloat = (arc4random_uniform(2) == 0) ? 1.0 : -1.0
        return randomNumber * (max - min) + min
    }
}
