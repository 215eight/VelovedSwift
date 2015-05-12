//
//  OSX_SnakeView.swift
//  SnakeSwift
//
//  Created by enadrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit
import SnakeCommon

struct OSX_SnakeView: StageElementView {

    var views = [AnyObject]()

    init(element: StageElement, transform: StageViewTransform) {
        views = initViews(element, transform: transform)
    }

    private func initViews(element: StageElement, transform: StageViewTransform) -> [AnyObject] {

        var views = [NSView]()

        var index = 0
        for location in element.locations {
            let viewFrame = transform.getFrame(location)
            let view = getView(viewFrame)
            view.layer?.backgroundColor = getViewColor(element)

            let label = NSTextField(frame: view.bounds)
            label.bezeled = false
            label.drawsBackground = false
            label.editable = false
            label.selectable = false
            label.stringValue = String(format: "%i", arguments: [index++])
            view.addSubview(label)

            views.append(view)
        }
        return views
    }
    
    private func getView(frame: CGRect) -> NSView {
        let view = NSView(frame: frame)
        view.wantsLayer = true
        return view
    }

    private func getViewColor(element: StageElement) -> CGColorRef{
        if let snake = element as? Snake {
            switch snake.type {
            case .Solid:
                return NSColor.greenColor().CGColor
            case .Squared:
                return NSColor.blueColor().CGColor
            case .Dots:
                return NSColor.cyanColor().CGColor
            case .Stripes:
                return NSColor.magentaColor().CGColor
            default:
                return NSColor.blackColor().CGColor
            }
        } else {
            return NSColor.blackColor().CGColor
        }
    }
}