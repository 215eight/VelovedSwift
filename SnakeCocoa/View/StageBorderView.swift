//
//  StageBorderView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/9/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class StageBorderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGrayColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.0
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
