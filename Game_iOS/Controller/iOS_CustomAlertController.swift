//
//  iOS_CustomAlertController.swift
//  VelovedGame
//
//  Created by eandrade21 on 6/21/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

enum iOS_InfoAlertControllerType {
    case Waiting
    case Crashed
    case Won
}


class iOS_CustomAlertController: NSObject {

    class func getInfoAlertController(type: iOS_InfoAlertControllerType, backActionHandler: ((UIAlertAction!) -> Void), retryActionHandler: ((UIAlertAction!) -> Void)) -> UIAlertController {
        var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)

        configureBackAction(alertController, backActionHandler: backActionHandler)
        configureRetryAction(alertController, retryActionHandler: retryActionHandler)
        configureAlert(alertController, type: type)
        return alertController
    }

    class func getErrorAlertController() -> UIAlertController {
        var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)

        configureDismissAction(alertController)
        configureErrorAlert(alertController)

        return alertController
    }

    private class func configureBackAction(alertController: UIAlertController, backActionHandler: ((UIAlertAction!) -> Void)) {
        let backAction = UIAlertAction(title: InfoAlertMainMenuActionTitle,
            style: UIAlertActionStyle.Default,
            handler: backActionHandler)

        alertController.addAction(backAction)
    }

    private class func configureRetryAction(alertController: UIAlertController, retryActionHandler: ((UIAlertAction!) ->  Void)) {
        let retryAction = UIAlertAction(title: InfoAlertRaceActionTitle,
            style: UIAlertActionStyle.Default,
            handler: retryActionHandler)

        alertController.addAction(retryAction)
    }

    private class func configureDismissAction(alertController: UIAlertController) {
        let dismissAction = UIAlertAction(title: ErrorAlertDismissActionTitle,
            style: UIAlertActionStyle.Default,
            handler: nil)

        alertController.addAction(dismissAction)
    }

    private class func configureAlert(alertController: UIAlertController, type: iOS_InfoAlertControllerType) {
        switch type {
        case .Waiting:
            configureWaitingAlert(alertController)
        case .Crashed:
            configureCrashedAlert(alertController)
        case .Won:
            configureWonAlert(alertController)
        default:
            assertionFailure("Unknown info alert controller type")
        }
    }

    private class func configureWaitingAlert(alertController: UIAlertController) {
        let attributedTitle = getAlertAttributedString(InfoAlertCrashedTitle,
            fontName: DefaultAppFontNameHeavy,
            fontSize: InfoAlertTitleFontSize)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")

        let attributedMessage = getAlertAttributedString(InfoAlertCrashedMessage,
            fontName: DefaultAppFontNameLight,
            fontSize: InfoAlertMessageFontSize)
        alertController.setValue(attributedMessage, forKey: "attributedMessage")


        alertController.view.tintColor = UIColor.blackColor()
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

        alertController.actions.map() { ($0 as! UIAlertAction).enabled = false }


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

    private class func configureErrorAlert(alertController: UIAlertController) {
        let attributedTitle = getAlertAttributedString(ErrorAlertTitle,
            fontName: DefaultAppFontNameHeavy,
            fontSize: InfoAlertTitleFontSize)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")

        let attributedMessage = getAlertAttributedString(ErrorAlertMessage,
            fontName: DefaultAppFontNameLight,
            fontSize: InfoAlertMessageFontSize)
        alertController.setValue(attributedMessage, forKey: "attributedMessage")

        alertController.view.tintColor = UIColor.redColor()
    }

    private class func getAlertAttributedString(text: String, fontName: String, fontSize: CGFloat) -> NSMutableAttributedString {
        var attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSFontAttributeName,
            value: UIFont(name: fontName, size: fontSize)!,
            range: NSRange(location: 0, length:count(text)))

        attributedString.addAttribute(NSForegroundColorAttributeName,
            value: UIColor.blackColor(),
            range: NSRange(location: 0, length: count(text)))
        
        return attributedString
    }

    class func updateInfoAlertController(alertController: UIAlertController) {
        alertController.actions.map() { ($0 as! UIAlertAction).enabled = true }
        alertController.view.tintColor = UIColor.blackColor()

        let attributedMessage = getAlertAttributedString(InfoAlertUpdateCrashedMessage,
            fontName: DefaultAppFontNameLight,
            fontSize: InfoAlertMessageFontSize)
        alertController.setValue(attributedMessage, forKey: "attributedMessage")

    }
    
}