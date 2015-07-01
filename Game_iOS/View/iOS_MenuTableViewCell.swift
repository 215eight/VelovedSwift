//
//  iOS_MenuTableViewCell.swift
//  VelovedGame
//
//  Created by eandrade21 on 6/30/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class iOS_MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTap(sender: UIButton) {
        println("Button Tapped")
    }
}
