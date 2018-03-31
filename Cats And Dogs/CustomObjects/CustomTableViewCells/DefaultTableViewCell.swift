//
//  DefaultTableViewCell.swift
//  Cats And Dogs
//
//  Created by Levi on 3/5/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.StyleFile.DarkBlueGray
        self.isUserInteractionEnabled = true
        self.textLabel?.textColor = UIColor.StyleFile.LightBlueGray
        self.textLabel?.font = UIFont.StyleFile.latoLight
        self.textLabel?.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
