//
//  OSX_ObstacleView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit

class OSX_ObstacleView: NSView, StageElementView {

    class func getStageElementView(element: StageElement, transform: StageViewTransform) -> StageElementView {

        let obstacleView = OSX_ObstacleView()

        for location in element.locations {
            let subviewFrame = transform.getFrame(location)
            let subView = OSX_ObstacleView.getSubview(subviewFrame)
            obstacleView.addSubview(subView)
        }
        return obstacleView
    }

    class private func getSubview(frame: CGRect) -> NSView {
        let subview = NSView(frame: frame)
        subview.wantsLayer = true
        subview.layer?.backgroundColor = NSColor.blackColor().CGColor
        return subview
    }
}