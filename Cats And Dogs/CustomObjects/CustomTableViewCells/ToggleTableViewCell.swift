//
//  ToggleTableViewCell.swift
//  Cats And Dogs
//
//  Created by Levi on 3/5/18.
//  Copyright © 2018 App Volks. All rights reserved.
//

import UIKit

class ToggleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var toggle: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.StyleFile.DarkBlueGray
        self.selectionStyle = .none
        self.isUserInteractionEnabled = true
        self.textLabel?.textColor = UIColor.StyleFile.LightBlueGray
        self.textLabel?.font = UIFont.StyleFile.latoLight
        self.bringSubview(toFront: toggle)
        self.textLabel?.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
