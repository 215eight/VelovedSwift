//
//  iOS_CustomViewController.swift
//  VelovedGame
//
//  Created by eandrad21 on 6/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon


class iOS_CustomViewController: UIViewController {

    var errorCode: GameError?

    override func viewWillAppear(animated: Bool) {
        setUpNavigationGestureRecognizers()
        super.viewWillAppear(animated)
    }
    
    func setUpNavigationGestureRecognizers() {
        let backNavigationGS = UISwipeGestureRecognizer(target: self, action: "backNavigation:")
        backNavigationGS.numberOfTouchesRequired = 2
        backNavigationGS.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(backNavigationGS)
    }

    func backNavigation(gestureRecognizer: UIGestureRecognizer?) {
        navigationController?.popViewControllerAnimated(true)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
            

}
