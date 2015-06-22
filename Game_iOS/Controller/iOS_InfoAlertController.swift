//
//  iOS_InfoAlertController.swift
//  GameSwift
//
//  Created by eandrade21 on 6/21/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import GameCommon

enum InfoAlertControllerType {
    case Crashed
    case Won
}


class InfoAlertController: NSObject {

    class func getInforAlertController(type: InfoAlertControllerType, parentController: UIViewController) -> UIAlertController {
        var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        configureAlertActions(alertController, parentController: parentController)
        configureAlert(alertController, type: type)
        return alertController
    }

    private class func configureAlertActions(alertController: UIAlertController, parentController: UIViewController) {

        let mainMenuAction = UIAlertAction(title: InfoAlertMainMenuActionTitle,
            style: UIAlertActionStyle.Default) {
                (action) -> Void in
                if let navController = parentController.navigationController {
                    navController.popToRootViewControllerAnimated(true)
                }
        }
        alertController.addAction(mainMenuAction)

        let raceAction = UIAlertAction(title: InfoAlertRaceActionTitle,
            style: UIAlertActionStyle.Default) {
                (action) -> Void in
                if let navController = parentController.navigationController {
                    navController.popViewControllerAnimated(true)
                }
        }
        alertController.addAction(raceAction)

    }

    private class func configureAlert(alertController: UIAlertController, type: InfoAlertControllerType) {
        switch type {
        case .Crashed:
            configureCrashedAlert(alertController)
        case .Won:
            configureWonAlert(alertController)
        }
    }

    private class func configureCrashedAlert(alertController: UIAlertController) {
        let attributedTitle = getAlertAttributedString(InfoAlertCrashedTitle,
            fontName: DefaultAppFontNameHeavy,
            fontSize: InfoAlertTitleFontSize)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")

        let attributedMessage = getAlertAttributedString(InfoAlertCrashedMessage,
            fontName: DefaultAppFontNameLight,
            fontSize: InfoAlertMessageFontSize)
        alertController.setValue(attributedMessage, forKey: "attributedMessage")

        alertController.actions.map() { ($0 as UIAlertAction).enabled = false }


        alertController.view.tintColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
    }

    private class func configureWonAlert(alertController: UIAlertController) {
        let attributedTitle = getAlertAttributedString(InfoAlertWonTitle,
            fontName: DefaultAppFontNameHeavy,
            fontSize: InfoAlertTitleFontSize)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")

        let attributedMessage = getAlertAttributedString(InfoAlertWonMessage,
            fontName: DefaultAppFontNameLight,
            fontSize: InfoAlertMessageFontSize)
        alertController.setValue(attributedMessage, forKey: "attributedMessage")

        alertController.view.tintColor = UIColor.blackColor()
    }

    private class func getAlertAttributedString(text: String, fontName: String, fontSize: CGFloat) -> NSMutableAttributedString {
        var attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSFontAttributeName,
            value: UIFont(name: fontName, size: fontSize)!,
            range: NSRange(location: 0, length: countElements(text)))

        attributedString.addAttribute(NSForegroundColorAttributeName,
            value: UIColor.blackColor(),
            range: NSRange(location: 0, length: countElements(text)))
        
        return attributedString
    }
    
}