//
//  ButtonView.swift
//  GameSwift
//
//  Created by eandrade on 6/24/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SymbolView: UIView {

    override init(frame: CGRect) {

        let newSide = min(frame.size.width / 4, frame.size.height / 4)
        let newSize = CGSize(width: newSide, height: newSide)
        let newOrigin = CGPoint(x: (frame.size.width / 2) - newSide / 2 , y: (frame.size.height / 2) - newSide / 2)
        let newFrame = CGRect(origin: newOrigin, size: newSize)

        super.init(frame: newFrame)

        backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
