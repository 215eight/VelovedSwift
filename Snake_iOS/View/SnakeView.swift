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
    
    convenience init(frame: CGRect, type: SnakeType) {
        self.init(frame: frame)
        backgroundColor = getColor(type)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func getColor(type: SnakeType) -> UIColor {
        switch type {
        case .Solid:
            return UIColor.greenColor()
        case .Squared:
            return UIColor.purpleColor()
        case .Dots:
            return UIColor.magentaColor()
        }
    }
    
}
