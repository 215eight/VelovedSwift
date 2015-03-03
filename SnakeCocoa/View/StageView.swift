//
//  StageView.swift
//  SnakeSwift
//
//  Created by PartyMan on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class StageView: UIView {

    // MARK: Properties
    let cornerRadius : CGFloat = 20.0
    let lineWidth : CGFloat = 20.0
    
    // MARK: UIView Methods
    override func drawRect(rect: CGRect) {
        
        // Inset Rect
        let insetRect = CGRectInset(self.bounds, lineWidth / 4 , lineWidth / 4)
        
        let path = UIBezierPath(roundedRect: insetRect, cornerRadius: cornerRadius)
        path.lineWidth = 5.0
        UIColor.blackColor().setStroke()
        path.stroke()
    }

}
