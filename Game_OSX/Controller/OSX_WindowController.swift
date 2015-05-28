//
//  OSX_WindowController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa

class OSX_WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        if let scaledFrame = OSX_WindowResizer.resizeWindowProportionalToScreenResolution(0.5) {
            if let win = window {
                win.setFrame(scaledFrame, display: true)
            }
        }
    }
}
