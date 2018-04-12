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
    var moveAnimation: SKAction!
    
    init() {
        let texture = SKTexture(imageNamed: "CDrop.pdf")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = "drop"
    }

    func createLetterDrop(drop: Drop) -> Drop {
        let letterDrop = drop
        let randomDrop = Drop.dropTypes[Int(arc4random_uniform(6))]
        letterDrop.texture = SKTexture(imageNamed: "\(randomDrop)Drop.pdf")
        letterDrop.type = randomDrop
        return letterDrop
    }
    
    func createLevelDrop(drop: Drop) -> Drop {
        let levelDrop = drop
        levelDrop.texture = SKTexture(imageNamed: "\(-GameVariables.levelMissPoints)Drop.pdf")
        self.type = "levelDrop"
        return levelDrop
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    enum DropType: String {
        case D, O, G, C, A, T
    }
}
