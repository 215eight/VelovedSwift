//
//  iOS_GameViewController.swift
//  VelovedGame
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

class iOS_GameViewController: iOS_CustomViewController {

    var gameController: GameController!
    var stageView: iOS_StageView?

    init(gameMode: GameMode) {
        super.init(nibName: "iOS_GameViewController", bundle: nil)

        switch gameMode {
        case .SinglePlayer:
            gameController = SinglePlayerGameController()
        case .MultiPlayer:
            gameController = MultiplayerGameController()
            MPCController.sharedMPCController.delegate = gameController as MultiplayerGameController
            MPCController.sharedMPCController.operationMode = .SendAndReceive
        }

        gameController.viewController = self

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "deviceOrientationDidChange:",
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIDeviceOrientationDidChangeNotification,
            object: nil)
        println("INFO: \(self) is being deinitialized")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameController.startGame()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        #if (TARGET_IPHONE_SIMULATOR)
        stageView?.becomeFirstResponder()
        #endif
    }

    override func viewWillDisappear(animated: Bool) {
        gameController.stopGame()
        MPCController.sharedMPCController.delegate = nil

        println("INFO: \(self) will disappear")
        super.viewWillDisappear(animated)
    }
    func deviceOrientationDidChange(notification: NSNotification) {
        stageView?.setUpGestureRecognizersDirection()
        drawViews()
    }

    func backNavigationHandler() -> ((UIAlertAction!) -> Void) {
        return { (action: UIAlertAction!) -> Void in
            if let _ = self.navigationController {
                self.navigationController?.popToRootViewControllerAnimated(true)
                MPCController.destroySharedMPCController()
            }
        }
    }

    func retryNavigationHandler() -> ((UIAlertAction!) -> Void) {

        if gameController.isMemberOfClass(SinglePlayerGameController) {
            return { (action: UIAlertAction!) -> Void in
                self.gameController.restartGame()
            }
        } else if gameController.isMemberOfClass(MultiplayerGameController) {
            return { (action: UIAlertAction!) -> Void in
                if let _ = self.navigationController {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        } else {
            return { (action: UIAlertAction!) -> Void in
                assertionFailure("ERROR: \(__FUNCTION__) - GameController unknow instance type")
            }
        }
    }
}

extension iOS_GameViewController: GameViewController {

    func setUpView() {

        stageView = iOS_StageView()
        stageView?.delegate = self
        stageView?.setUpGestureRecognizers()
        view.addSubview(stageView!)

        drawViews()
    }

    func drawViews() {

        dispatch_async(dispatch_get_main_queue()) {
            if let _ = self.stageView {
                self.stageView?.drawStage()
            }
        }

        for (_, elementCollection) in gameController.stage.elements {
            for element in elementCollection {
                drawElement(element)
            }
        }
    }

    func drawElement(element: StageElement) {
        dispatch_async(dispatch_get_main_queue()) {
            if let _ = self.stageView {
                self.stageView?.drawElement(element)
            }
        }
    }

    func destroy() {
        stageView?.resignFirstResponder()
        stageView?.dismantelGestureRecognizers()
        stageView?.delegate = nil
        stageView?.removeFromSuperview()
        stageView = nil
    }

    override func backNavigation(gestureRecognizer: UIGestureRecognizer?) {

        if gameController.isMemberOfClass(MultiplayerGameController) {
            let peer  = MPCController.sharedMPCController.peerID
            let playerLeftGame = MPCMessage.getPeerDidNotConnectMessage(peer)
            MPCController.sharedMPCController.sendMessage(playerLeftGame)
        }

        super.backNavigation(gestureRecognizer)
    }

    func showCrashedInfoAlertController() {

        let infoAlertController = iOS_CustomAlertController.getInfoAlertController(iOS_InfoAlertControllerType.Waiting,
            backActionHandler: backNavigationHandler(),
            retryActionHandler: retryNavigationHandler())

        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(infoAlertController, animated: true, completion: nil)
        }
    }

    func updateCrashedInfoAlertController() {

        if let viewController = presentedViewController {
            if let alertController = viewController as? UIAlertController {
                dispatch_async(dispatch_get_main_queue()) {
                    iOS_CustomAlertController.updateInfoAlertController(alertController)
                }
            }
        }
    }

    func showWonInfoAlertController() {

        let infoAlertController = iOS_CustomAlertController.getInfoAlertController(iOS_InfoAlertControllerType.Won,
            backActionHandler: backNavigationHandler(),
            retryActionHandler: retryNavigationHandler())

        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(infoAlertController, animated: true, completion: nil)
        }
    }

    func dismissGameViewController(errorCode: GameError) {
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationController?.popViewControllerAnimated(true)
            if let previousViewController  = self.navigationController?.visibleViewController {
                if let customViewController = previousViewController as? iOS_CustomViewController {
                    customViewController.errorCode = errorCode
                }
            }
        }
    }

}

extension iOS_GameViewController: InputViewDelegate {

    func processKeyInput(key: String, transform: StageViewTransform) {
        gameController.processKeyInput(key, transform: transform)
    }

    func processSwipe(direction: Direction) {
        gameController.processSwipe(direction)
    }

    func processPauseOrResumeTouch() -> Bool {
        gameController.processPauseOrResumeGame()
        return gameController.isGameRunning()
    }
}