//
//  SettingsViewController.swift
//  Cats And Dogs
//
//  Created by Levi on 3/3/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import CoreData

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomLayout: NSLayoutConstraint!
    
    let sectionHeaders = ["GO TO...","SOUND OPTIONS","FEEDBACK","MORE APPS","HIGH SCORES"]
    let optionsTitles = ["Music","Rain","Sound FX"]
    
    var highScoreToDisplay: HighScore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        CoreDataHelper().getHighScores()
        print("settings view loaded")
    }
    
    override func viewWillLayoutSubviews() {
        backgroundBottomLayout.constant += (self.view.safeAreaInsets.bottom)
        tableViewBottomLayout.constant += (self.view.safeAreaInsets.bottom)
        print("settings view laid out")
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
        if HighScoresClass.highScores.count > 0 {
            count = 5
        } else {
            count = 4
        }
        return count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isKind(of: DefaultTableViewCell.self) {
                switch indexPath.section {
                case 0:
                    switch indexPath.row {
                    case 0:
                        performSegue(withIdentifier: "settingsToAchievements", sender: self)
                    case 1:
                        performSegue(withIdentifier: "settingsToTutorial", sender: self)
                    case 2:
                        performSegue(withIdentifier: "settingsToCreditsViewController", sender: self)
                    default:
                        print("should never fire")
                    }
                case 2:
                    switch indexPath.row {
                    case 0:
                        print("review pressed")
                        SKStoreReviewController.requestReview()
                    case 1:
                        print("mail pressed")
                        if MFMailComposeViewController.canSendMail() {
                            let composeVC = MFMailComposeViewController()
                            composeVC.mailComposeDelegate = self
                            composeVC.setToRecipients(["levilais@gmail.com"])
                            composeVC.setSubject("Cats & Dogs Feedback")
                            composeVC.setMessageBody("A note from Cats & Dogs: We are always committed to making Cats & Dogs the best experience possible.  Please let us know what you think!", isHTML: false)
                            self.present(composeVC, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Bummer!", message: "It looks like you are not able to send email at this time!  Please check your connection and/or settings and try again.", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(action)
                            present(alert, animated: true)
                        }
                    default:
                        print("should never fire")
                    }
                case 3:
                    switch indexPath.row {
                    case 0:
                        let urlStr = "itms://itunes.apple.com/us/app/random-ruby/id1296326011?ls=1&mt=8"
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
                            
                        } else {
                            UIApplication.shared.openURL(URL(string: urlStr)!)
                        }
                    case 1:
                        let urlStr = "itms://itunes.apple.com/us/app/prayer-swipe-to-send/id1303817456?ls=1&mt=8"
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
                            
                        } else {
                            UIApplication.shared.openURL(URL(string: urlStr)!)
                        }
                    default:
                        print("should never fire")
                    }
                default:
                    print("error")
                }
                // perform segue if necessary
                tableView.deselectRow(at: indexPath, animated: true)
            } else if cell.isKind(of: HighScoreTableViewCell.self) {
                print("selected high score")
                self.highScoreToDisplay = HighScoresClass.highScores[indexPath.row]
                self.performSegue(withIdentifier: "settingsToScoreStatsSegue", sender: self)
            }
        }
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                self?.present(storeViewController, animated: true, completion: nil)
            }
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = Int()
        switch section {
        case 0:
            rows = 3
        case 1:
            rows = 3
        case 2:
            rows = 2
        case 3:
            rows = 2
        case 4:
            rows = HighScoresClass.highScores.count
        default:
            rows = 1
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "Achievements"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "Tutorial"
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "Credits"
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "toggleTableViewCell", for: indexPath) as! ToggleTableViewCell
            cell.textLabel?.text = optionsTitles[indexPath.row]
            switch indexPath.row {
            case 0:
                // music
                if UserPrefs.musicAllowed {
                    cell.toggle.setOn(true, animated: false)
                } else {
                    cell.toggle.setOn(false, animated: false)
                }
                cell.toggle.addTarget(self, action: #selector(toggleAllowMusic(toggleSwitch:)), for: .touchUpInside)
            case 1:
                // rain
                if UserPrefs.rainAllowed {
                    cell.toggle.setOn(true, animated: false)
                } else {
                    cell.toggle.setOn(false, animated: false)
                }
                cell.toggle.addTarget(self, action: #selector(toggleAllowRain(toggleSwitch:)), for: .touchUpInside)
            case 2:
                // sfx
                if UserPrefs.soundFxAllowed {
                    cell.toggle.setOn(true, animated: false)
                } else {
                    cell.toggle.setOn(false, animated: false)
                }
                cell.toggle.addTarget(self, action: #selector(toggleAllowSoundFx(toggleSwitch:)), for: .touchUpInside)
            default:
                print("default called")
            }
            return cell
        case 2:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "Review"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "Give Feedback"
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                return cell
            }
        case 3:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "Random Ruby"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                cell.textLabel?.text = "Prayer"
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
                cell.isUserInteractionEnabled = true
                return cell
            }
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreTableViewCell", for: indexPath) as! HighScoreTableViewCell
            cell.detailTextLabel?.textColor = UIColor.StyleFile.LightBlueGray
            let highScore = HighScoresClass.highScores[indexPath.row]
            if let formattedScore = HighScore().formattedScore(score: highScore.score) {
                cell.textLabel?.text = formattedScore
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
            cell.detailTextLabel?.text = ("\(highScore.playerName!) on \(dateFormatter.string(from: highScore.timestamp))")
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableViewCell", for: indexPath) as! DefaultTableViewCell
            return cell
        }
    }
    
    @objc func toggleAllowMusic(toggleSwitch: UISwitch) {
        togglePref(switchType: "music")
    }
    @objc func toggleAllowRain(toggleSwitch: UISwitch) {
        togglePref(switchType: "rain")
    }
    @objc func toggleAllowSoundFx(toggleSwitch: UISwitch) {
        togglePref(switchType: "soundFx")
    }

    func togglePref(switchType: String) {
        switch switchType {
        case "music":
            if UserPrefs.musicAllowed {
                UserPrefs.musicAllowed = false
                if let musicPlayer = GameAudio.backgroundMusicPlayer {
                    musicPlayer.stop()
                }
                if GameAudio.drumsAudioPlayer != nil {
                    GameAudio().stopAndResetDrums()
                }
                GameAudio().setupMusicPlayer()
            } else {
                UserPrefs.musicAllowed = true
                GameAudio().setupMusicPlayer()
                if GameVariables.gameIsActive {
                    GameAudio().resetBackgroundMusic()
                }
            }
        case "rain":
            if UserPrefs.rainAllowed {
                UserPrefs.rainAllowed = false
                if let rainPlayer = GameAudio.rainAudioPlayer {
                    rainPlayer.stop()
                }
                if let thunderPlayer = GameAudio.thunderAudioPlayer {
                    thunderPlayer.stop()
                }
            } else {
                UserPrefs.rainAllowed = true
                if let rainPlayer = GameAudio.rainAudioPlayer {
                    rainPlayer.play()
                } else {
                    GameAudio().setupRainPlayer()
                    if let rainAudioPlayer = GameAudio.rainAudioPlayer {
                        rainAudioPlayer.play()
                    }
                    if let thunderAudioPlayer = GameAudio.thunderAudioPlayer {
                        thunderAudioPlayer.play()
                    }
                }
            }
        case "soundFx":
            if UserPrefs.soundFxAllowed {
                UserPrefs.soundFxAllowed = false
            } else {
                UserPrefs.soundFxAllowed = true
            }
        default:
            print("default called")
        }
        UserPrefs().saveUserPrefs()
    }
    
    @IBAction func goBackDidPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsToScoreStatsSegue" {
            if let highScore = self.highScoreToDisplay {
                if let destinationVC = segue.destination as? ScoreStatsViewController {
                    destinationVC.scoreToDisplay = highScore
                }
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        var labelText = ""
        
        switch result {
        case .cancelled:
            print("cancelled")
        case .sent:
            labelText = "Sent!"
        case .saved:
            labelText = "Saved!"
        case .failed:
            print("failed")
        }
        
        controller.dismiss(animated: true) {
            print("controller dismiss called")
        }
    }
}
