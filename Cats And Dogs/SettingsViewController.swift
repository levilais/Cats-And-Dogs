//
//  SettingsViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 3/3/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomLayout: NSLayoutConstraint!
    
    let sectionHeaders = ["OPTIONS","CONNECT","HIGH SCORES"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        for highScore in HighScores.highScores {
            if let score = highScore.score {
                if let playerName = highScore.playerName {
                    print("name \(playerName) scored \(score)")
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        backgroundBottomLayout.constant += (self.view.safeAreaInsets.bottom)
        tableViewBottomLayout.constant += (self.view.safeAreaInsets.bottom)
    }
    
    func setupTableView() {
        let height: CGFloat = 140 + self.view.safeAreaInsets.top
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height))
        tableView.tableHeaderView?.backgroundColor = .clear
        
        let footerHeight: CGFloat = 10 + self.view.safeAreaInsets.bottom
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: footerHeight))
        tableView.tableFooterView?.backgroundColor = .clear
        
        tableView.showsVerticalScrollIndicator = false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = sectionHeaders[section]
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (view is UITableViewHeaderFooterView) {
            if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
                tableViewHeaderFooterView.contentView.backgroundColor = .clear
                return tableViewHeaderFooterView
            } else {
                return UIView()
            }
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (view is UITableViewHeaderFooterView) {
            if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
                print()
                tableViewHeaderFooterView.contentView.backgroundColor = UIColor.StyleFile.LightBlueGray
                tableViewHeaderFooterView.textLabel?.font = UIFont.StyleFile.latoBold
                tableViewHeaderFooterView.textLabel?.textColor = UIColor.StyleFile.DarkBlueGray
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = Int()
        if HighScores.highScores.count > 0 {
            count = 3
        } else {
            count = 2
        }
        return count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isKind(of: DefaultTableViewCell.self) {
                print("is default")
                // perform segue
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = Int()
        switch section {
        case 0:
            rows = 1
        case 1:
            rows = 5
        case 2:
            rows = HighScores.highScores.count
        default:
            rows = 1
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "toggleTableViewCell", for: indexPath) as! ToggleTableViewCell
            cell.textLabel?.text = "Sound"
        case 1:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "toggleTableViewCell", for: indexPath) as! ToggleTableViewCell
                cell.textLabel?.text = "Facebook"
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "toggleTableViewCell", for: indexPath) as! ToggleTableViewCell
                cell.textLabel?.text = "GameCenter"
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "Review"
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "Give Feedback"
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "About"
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
            }
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "highScoreTableViewCell", for: indexPath) as! HighScoreTableViewCell
            cell.detailTextLabel?.textColor = UIColor.StyleFile.LightBlueGray
            let highScore = HighScores.highScores[indexPath.row]
            if let score = highScore.score {
                if let formattedScore = HighScore().formattedScore(score: score) {
                    cell.textLabel?.text = formattedScore
                }
                if let playerName = highScore.playerName {
                    cell.detailTextLabel?.text = playerName
                }
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
        }
        cell.textLabel?.backgroundColor = .clear
        return cell
    }

    @IBAction func goBackDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
