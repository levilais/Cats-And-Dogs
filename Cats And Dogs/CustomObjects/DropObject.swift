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
    static var lastDropXValue: CGFloat?
    
    var type: String!
    var scorePoints: Int?
    var missPoints: Int?
    var moveAnimation: SKAction!
    
    init() {
        let texture = SKTexture(imageNamed: "CDrop.pdf")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = "drop"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.zPosition = 10
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

class DropFunctions {
    func moveDrop(drop: Drop, scene: SKScene, view: SKView) {
        let currentSceneSize = scene.size
        let newSize = Utilities().resizeDropSpaceSize(view: view, currentSize: currentSceneSize)
        
        let maxStartingX = newSize.width / 2 - drop.size.width / 2 - 30
        let minStartingX = -newSize.width / 2 + drop.size.width / 2
        let startingXRange = maxStartingX - minStartingX
        
        var startingX = CGFloat()
        if let lastX = Drop.lastDropXValue {
            var startingXFound = false
            while !startingXFound {
                startingX = maxStartingX - CGFloat(arc4random_uniform(UInt32(startingXRange)))
                if (startingX - (drop.size.width + 20))...(startingX + (drop.size.width + 20)) ~= lastX {
                    print("too close")
                } else {
                    startingXFound = true
                }
            }
        } else {
            startingX = maxStartingX - CGFloat(arc4random_uniform(UInt32(startingXRange)))
        }
        
        let startingY: CGFloat = scene.size.height / 2 + drop.size.height / 2
        drop.position = CGPoint(x: startingX, y: startingY)
        
        Drop.lastDropXValue = startingX
        
        let moveDown = SKAction.moveBy(x: 0, y: -scene.size.height - drop.size.height, duration: GameControls.initialDropDuration)
        drop.speed = GameVariables.dropSpeed
        drop.run(moveDown)
    }
}
