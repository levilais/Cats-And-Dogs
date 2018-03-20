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
    let sectionHeaders = ["Score","Time","Level","Skipped Levels","Hits","Misses","Accuracy","Combos","Longest Streak"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillLayoutSubviews() {
        backgroundBottomLayoutConstraint.constant += (self.view.safeAreaInsets.bottom)
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
        return sectionHeaders.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreStatsTableViewCell", for: indexPath) as! ScoreStatsTableViewCell
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func exitButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
