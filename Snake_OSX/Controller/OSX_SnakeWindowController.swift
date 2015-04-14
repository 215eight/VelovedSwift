//
//  OSX_SnakeWindowController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa

class OSX_SnakeWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        if let scaledFrame = OSX_WindowResizer.resizeWindowProportionalToScreenResolution(0.8) {
            if let win = window {
                win.setFrame(scaledFrame, display: true)
            }
        }
    }

}
