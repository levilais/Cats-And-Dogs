//
//  Utilities.swift
//  Cats And Dogs
//
//  Created by Levi on 2/25/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Utilities {
    // NOTE: These resizing formulas may need to take into account safe areas on the right and left if there are any new devices
    func shiftHorizontal(view: SKView, currentPosition: CGPoint) -> CGPoint {
        let posth = view.frame.height
        let top = view.safeAreaInsets.top
        let bottom = view.safeAreaInsets.bottom
        let increase = top + bottom
        let increase2 = increase * 2
        let preh = posth - increase2
        let percent = preh / posth
        let newY = currentPosition.y
        let newX = currentPosition.x * percent
        let newPoint = CGPoint(x: newX, y: newY)
        return newPoint
    }
    
    func shiftDown(view: SKView, currentPosition: CGPoint) -> CGPoint {
        let newY = currentPosition.y - view.safeAreaInsets.top
        let newX = currentPosition.x
        let newPoint = CGPoint(x: newX, y: newY)
        return newPoint
    }
    
    func shiftUp(view: SKView, currentPosition: CGPoint) -> CGPoint {
        let newY = currentPosition.y + view.safeAreaInsets.bottom
        let newX = currentPosition.x
        let newPoint = CGPoint(x: newX, y: newY)
        return newPoint
    }
    
    func resizespriteNode(spriteNode: SKSpriteNode, view: SKView) {
        let posth = view.frame.height
        let top = view.safeAreaInsets.top
        let bottom = view.safeAreaInsets.bottom
        let increase = top + bottom
        let increase2 = increase * 2
        let preh = posth - increase2
        let percent = preh / posth
        
        let newWidth = spriteNode.size.width * percent
        let newHeight = spriteNode.size.height * percent
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        spriteNode.size = newSize
    }
    
    func resizeLabelNode(labelNode: SKLabelNode, view: SKView) {
        let posth = view.frame.height
        let top = view.safeAreaInsets.top
        let bottom = view.safeAreaInsets.bottom
        let increase = top + bottom
        let increase2 = increase * 2
        let preh = posth - increase2
        let percent = preh / posth
        let newFontSize = labelNode.fontSize * percent
        
        labelNode.fontSize = newFontSize
    }
    
    func resizeDropSpaceSize(view: SKView, currentSize: CGSize) -> CGSize {
        let posth = view.frame.height
        let top = view.safeAreaInsets.top
        let bottom = view.safeAreaInsets.bottom
        let increase = top + bottom
        let increase2 = increase * 2
        let preh = posth - increase2
        let percent = preh / posth
        let newWidth = currentSize.width * percent
        let newHeight = currentSize.height * percent
        let newSize = CGSize(width: newWidth, height: newHeight)
        return newSize
    }
    
    func showSettings(scene: SKScene) {
        let settingsLabel = SKLabelNode()
        settingsLabel.fontName = "AmaticSC-Regular"
        settingsLabel.fontSize = 128
        settingsLabel.fontColor = .white
        settingsLabel.position = CGPoint(x: 0, y: scene.frame.height / 2)
        scene.addChild(settingsLabel)
    }
}

public extension Double {
    // Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


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
