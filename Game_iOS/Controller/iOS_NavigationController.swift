//
//  iOS_NavigationController.swift
//  VelovedGame
//
//  Created by PartyMan on 7/5/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class iOS_NavigationController: UINavigationController {

    override func shouldAutorotate() -> Bool {
        return topViewController.shouldAutorotate()
    }

    override func supportedInterfaceOrientations() -> Int {
        return topViewController.supportedInterfaceOrientations()
    }

}
