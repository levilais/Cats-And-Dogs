//
//  SettingsScene.swift
//  Cats And Dogs
//
//  Created by Levi on 3/2/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsScene: SKScene {
    
//    var gameTableView = GameRoomTableView()
//    private var label : SKLabelNode?
    
    override func didMove(to view: SKView) {
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        // Table setup
//        gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        gameTableView.frame=CGRect(x:20,y:50,width:280,height:200)
//        self.scene?.view?.addSubview(gameTableView)
//        gameTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)

            if let name = touchedNode.name {
                switch name {
                case "quitButton":
                    if let view = self.view as! SKView? {
                        if let gameScene = SKScene(fileNamed: "GameScene") {
                            gameScene.scaleMode = .aspectFill
                            view.presentScene(gameScene)
                        }
                    }
                default:
                    print("no button touched")
                }
            }
        }
    }

}

//class GameRoomTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
//    var items: [String] = ["Player1", "Player2", "Player3"]
//    override init(frame: CGRect, style: UITableViewStyle) {
//        super.init(frame: frame, style: style)
//        self.delegate = self
//        self.dataSource = self
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    // MARK: - Table view data source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
//        cell.textLabel?.text = self.items[indexPath.row]
//        return cell
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("You selected cell #\(indexPath.row)!")
//    }
//}

