//
//  DropObject.swift
//  Cats And Dogs
//
//  Created by Levi on 2/25/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Drop: SKSpriteNode {
    static var dropTypes = ["D","O","G","C","A","T"]
    
    var type: String!
    var scorePoints: Int?
    var missPoints: Int?
    
    init() {
        let randomDrop = Drop.dropTypes[Int(arc4random_uniform(6))]
        self.type = randomDrop
        let texture = SKTexture(imageNamed: "\(randomDrop)Drop.pdf")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    enum DropType: String {
        case D, O, G, C, A, T
    }
}
