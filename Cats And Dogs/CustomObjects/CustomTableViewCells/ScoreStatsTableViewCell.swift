//
//  ScoreStatsTableViewCell.swift
//  Cats And Dogs
//
//  Created by Levi on 3/20/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class ScoreStatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.StyleFile.DarkBlueGray
        self.selectionStyle = .none
        self.scoreLabel?.textColor = UIColor.StyleFile.LightBlueGray
        self.scoreLabel?.font = UIFont.StyleFile.latoLight
        self.rankLabel?.textColor = UIColor.StyleFile.LightBlueGray
        self.rankLabel?.font = UIFont.StyleFile.latoLight
        self.recordLabel?.textColor = UIColor.StyleFile.LightBlueGray
        self.recordLabel?.font = UIFont.StyleFile.latoLight
        self.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
