//
//  SnakeView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SnakeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.greenColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
