//
//  OSX_AppleView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit

class OSX_AppleView: NSView, StageElementView {

    class func getStageElementView(element: StageElement, transform: StageViewTransform) -> OSX_AppleView {
        let appleView = OSX_AppleView()

        for location in element.locations {
            let subviewFrame = transform.getFrame(location)
            let subView = OSX_AppleView.getSubview(subviewFrame)
            appleView.addSubview(subView)
        }
        return appleView
    }

    class private func getSubview(frame: CGRect) -> NSView {
        let subview = NSView(frame: frame)
        subview.wantsLayer = true
        subview.layer?.backgroundColor = NSColor.redColor().CGColor
        return subview
    }
}
