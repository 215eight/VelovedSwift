//
//  AppDelegate.swift
//  Game_OSX
//
//  Created by eandrade21 on 4/10/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa
import GameCommon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController: OSX_MainWindowController?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if mainWindowController == nil {
            mainWindowController = OSX_MainWindowController(windowNibName: "OSX_MainWindowController")
        }
        mainWindowController?.showWindow(self)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

