//
//  PauseButtonView.swift
//  BikeView
//
//  Created by eandrade21 on 6/24/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class PauseButtonView: SymbolView {

    override func drawRect(rect: CGRect) {

        let path = UIBezierPath(ovalInRect: bounds)
        grayColor.setFill()
        path.fill()

        let boundsCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let pauseBarWidth: CGFloat = bounds.width * 1 / 6
        let pauseBarHeight: CGFloat = cos(degree2radian(30)) * (bounds.width * 3 / 5)
        let pauseBarSeparation: CGFloat = bounds.width * 3 / 7

        let originLeftBar = CGPoint(x: boundsCenter.x - pauseBarSeparation / 2, y: boundsCenter.y - pauseBarHeight / 2)
        let originRightBar = CGPoint(x: boundsCenter.x + pauseBarSeparation / 2 - pauseBarWidth, y: boundsCenter.y - pauseBarHeight / 2)
        let barSize = CGSize(width: pauseBarWidth, height: pauseBarHeight)

        let leftBarRect = CGRect(origin: originLeftBar, size: barSize)
        let rightBarRect = CGRect(origin: originRightBar, size: barSize)

        UIColor.whiteColor().setFill()
        let righBarPath = UIBezierPath(rect: rightBarRect)
        righBarPath.fill()

        let leftBarPath = UIBezierPath(rect: leftBarRect)
        leftBarPath.fill()
    }
}