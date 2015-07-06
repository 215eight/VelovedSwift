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

    var backButton: UIButton!
    var errorCode: GameError?
    var disableBackNavigationSwipe: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        disableBackNavigationSwipe = false

        let backButtonSize = CGSize(width: view.bounds.width * 0.05 , height: view.bounds.height * 0.05)
        backButton = UIButton(frame: CGRect(origin: CGPointZero, size: backButtonSize))
        backButton.titleLabel?.textAlignment = .Center
        backButton.backgroundColor = UIColor.clearColor()

        let attributedString = NSMutableAttributedString(string: "❮")
        attributedString.addAttribute(NSFontAttributeName,
            value: UIFont(name: DefaultAppFontNameHeavy, size: 30)!,
            range: NSRange(location: 0, length: 1))

        attributedString.addAttribute(NSForegroundColorAttributeName,
            value: pinkColor,
            range: NSRange(location: 0, length: 1))

        backButton.setAttributedTitle(attributedString, forState: .Normal)
        backButton.setTitleColor(pinkColor, forState: .Normal)

        backButton.addTarget(self, action: "backNavigation", forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(backButton)
    }

    override func viewWillAppear(animated: Bool) {
        setUpNavigationGestureRecognizers()
        super.viewWillAppear(animated)
    }
    
    func setUpNavigationGestureRecognizers() {
        let backNavigationGS = UISwipeGestureRecognizer(target: self, action: "backNavigation:")
        backNavigationGS.numberOfTouchesRequired = 1
        backNavigationGS.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(backNavigationGS)
    }

    func backNavigation(gestureRecognizer: UIGestureRecognizer?) {
        if !disableBackNavigationSwipe {
            backNavigation()
        }
    }

    func backNavigation() {
        navigationController?.popViewControllerAnimated(true)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }
}
