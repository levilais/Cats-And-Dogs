//
//  ScoreStatsViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 3/20/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class ScoreStatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundBottomLayoutConstraint: NSLayoutConstraint!
    
    var scoreToDisplay: HighScore!
    var isComingFromGameOverScene: Bool?
    
    let sectionHeaders = ["Player","Score","Time","Level","Skipped Level-Ups","Hits","Misses","Accuracy","Combos","Longest Streak","Best Drop Score"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        if isComingFromGameOverScene != nil {
            if isComingFromGameOverScene! {
                scoreToDisplay = GameVariables.gameOverHighScore
                print(GameVariables.gameOverHighScore?.score)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        backgroundBottomLayoutConstraint.constant -= (self.view.safeAreaInsets.bottom)
        tableViewBottomLayoutConstraint.constant += (self.view.safeAreaInsets.bottom)
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
        var sectionTitle = String()
        if section == 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            sectionTitle = ("\(scoreToDisplay.playerName!) on \(dateFormatter.string(from: scoreToDisplay.timestamp))")
            
        } else {
            sectionTitle = sectionHeaders[section]
        }
        
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
                
                tableViewHeaderFooterView.textLabel?.textAlignment = .center
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = Int()
        if section == 0 {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreStatsTableViewCell", for: indexPath) as! ScoreStatsTableViewCell
        cell.scoreLabel.text = "999,999"
        cell.rankLabel.text = "Rank: 5th"
        cell.recordLabel.text = "Record: 1,000,000,000"
        
        switch indexPath.section {
        case 0:
            print("Player Name")
        case 1:
            print("Score")
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let formattedNumber = numberFormatter.string(from: scoreToDisplay.score as NSNumber) {
                cell.scoreLabel.text = String(formattedNumber)
            }
            if let rank = CoreDataHelper().scoreRank(highScore: scoreToDisplay) {
                cell.rankLabel.text = rank
            }
            if let record = CoreDataHelper().scoreRecord() {
                cell.recordLabel.text = record
            }
        case 2:
            print("Time")
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
            formatter.allowedUnits = [ .hour, .minute, .second ]
            if let formattedDuration = formatter.string(from: TimeInterval(scoreToDisplay.time)) {
                if scoreToDisplay.time > 60 {
                    cell.scoreLabel.text = "Time: \(formattedDuration)"
                } else {
                    cell.scoreLabel.text = "Time: \(formattedDuration) Seconds"
                }
            }
            
            if let rank = CoreDataHelper().timeRank(highScore: scoreToDisplay) {
                cell.rankLabel.text = rank
            }
            if let record = CoreDataHelper().timeRecord() {
                cell.recordLabel.text = record
            }
        case 3:
            print("Level")
            cell.scoreLabel.text = "Level \(scoreToDisplay.level)"
            if let rank = CoreDataHelper().levelRank(highScore: scoreToDisplay) {
                cell.rankLabel.text = rank
            }
            if let record = CoreDataHelper().levelRecord() {
                cell.recordLabel.text = record
            }
        case 4:
            print("Skipped Levels")
            cell.scoreLabel.text = "\(scoreToDisplay.skippedLevelUps) Skipped"
            if let rank = CoreDataHelper().skippedRank(highScore: scoreToDisplay) {
                cell.rankLabel.text = rank
            }
            if let record = CoreDataHelper().skippedRecord() {
                cell.recordLabel.text = record
            }
        case 5:
            print("Hits")
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let formattedNumber = numberFormatter.string(from: scoreToDisplay.poppedDrops as NSNumber) {
                cell.scoreLabel.text = "\(formattedNumber) Drops Popped"
            }
            if let rank = CoreDataHelper().hitsRank(highScore: scoreToDisplay) {
                cell.rankLabel.text = rank
            }
            if let record = CoreDataHelper().hitsRecord() {
                cell.recordLabel.text = record
            }
        case 6:
            print("Misses")
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let formattedNumber = numberFormatter.string(from: scoreToDisplay.missedDrops as NSNumber) {
                cell.scoreLabel.text = "\(formattedNumber) Drops Missed"
            }
            if let rank = CoreDataHelper().missesRank(highScore: scoreToDisplay) {
                cell.rankLabel.text = rank
            }
            if let record = CoreDataHelper().missesRecord() {
                cell.recordLabel.text = record
            }
        case 7:
            print("Accuracy")
            let accuracyString = String("\(Int(100*(scoreToDisplay.accuracy.rounded(toPlaces: 2))))%")
            cell.scoreLabel.text = accuracyString
            if let rank = CoreDataHelper().accuracyRank(highScore: scoreToDisplay) {
                cell.rankLabel.text = rank
            }
            if let record = CoreDataHelper().accuracyRecord() {
                cell.recordLabel.text = record
            }
        case 8:
            print("Combos")
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let formattedNumber = numberFormatter.string(from: scoreToDisplay.combos as NSNumber) {
                cell.scoreLabel.text = "\(formattedNumber) Total"
            }
            if let rank = CoreDataHelper().combosRank(highScore: scoreToDisplay) {
                cell.rankLabel.text = rank
            }
            if let record = CoreDataHelper().combosRecord() {
                cell.recordLabel.text = record
            }
        case 9:
            print("Longest Streak")
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let formattedNumber = numberFormatter.string(from: scoreToDisplay.longestStreak as NSNumber) {
                cell.scoreLabel.text = "\(formattedNumber) Straight"
            }
            if let rank = CoreDataHelper().streakRank(highScore: scoreToDisplay) {
                cell.rankLabel.text = rank
            }
            if let record = CoreDataHelper().streakRecord() {
                cell.recordLabel.text = record
            }
        case 10:
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            if let formattedNumber = numberFormatter.string(from: scoreToDisplay.bestDrop as NSNumber) {
                cell.scoreLabel.text = "\(formattedNumber)"
                print("bestDrop formatted: \(formattedNumber)")
                print("bestDrop not formatted: \(scoreToDisplay.bestDrop)")
            }
            if let rank = CoreDataHelper().bestDropRank(highScore: scoreToDisplay) {
                cell.rankLabel.text = rank
            }
            if let record = CoreDataHelper().bestDropRecord() {
                cell.recordLabel.text = record
            }
        default:
            print("default")
        }
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func exitButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
