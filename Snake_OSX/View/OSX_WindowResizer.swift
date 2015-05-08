//
//  OSX_WindowResizer.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit

struct OSX_WindowResizer {

    static func resizeWindowProportionalToScreenResolution(ratio: Float) -> CGRect? {

        assert(ratio > 0 && ratio <= 1, "Invalid paramenter. Ratio value between (0, 1]")

        if let mainScreenFrame = NSScreen.mainScreen()?.frame {

            let winWidth = Float(mainScreenFrame.width) * ratio
            let winHeight = Float(mainScreenFrame.height) * ratio
            let winSize = CGSize(width: CGFloat(winWidth), height: CGFloat(winHeight))

            let ratioComplement = 1.0 - ratio
            let halfRatioComplement = Float(ratioComplement) * 0.5
            let originX = Float(mainScreenFrame.width) * halfRatioComplement
            let originY = Float(mainScreenFrame.height) * halfRatioComplement
            let winOrigin = CGPoint(x: CGFloat(round(originX)), y: CGFloat(round(originY)))

            return CGRect(origin: winOrigin, size: winSize)
        }
        
        return nil
    }
}