//
//  OSX_SnakeView.swift
//  SnakeSwift
//
//  Created by enadrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit

struct OSX_SnakeView: StageElementView {

    var views = [AnyObject]()

    init(element: StageElement, transform: StageViewTransform) {
        views = initViews(element, transform: transform)
    }

    private func initViews(element: StageElement, transform: StageViewTransform) -> [AnyObject] {

        var views = [NSView]()

        for location in element.locations {
            let viewFrame = transform.getFrame(location)
            let view = getView(viewFrame)
            views.append(view)
        }
        return views
    }
    
    private func getView(frame: CGRect) -> NSView {
        let view = NSView(frame: frame)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.greenColor().CGColor
        return view
    }
}