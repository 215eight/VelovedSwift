//
//  OSX_SnakeView.swift
//  SnakeSwift
//
//  Created by enadrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit

class OSX_SnakeView: NSView, StageElementView {

    class func getStageElementView(element: StageElement, transform: StageViewTransform) -> OSX_SnakeView {
        let snakeView = OSX_SnakeView()

        for location in element.locations {
            let subviewFrame = transform.getFrame(location)
            let subView = OSX_SnakeView.getSubview(subviewFrame)
            snakeView.addSubview(subView)
        }
        return snakeView
    }
    
    class private func getSubview(frame: CGRect) -> NSView {
        let subview = NSView(frame: frame)
        subview.wantsLayer = true
        subview.layer?.backgroundColor = NSColor.greenColor().CGColor
        return subview
    }
}