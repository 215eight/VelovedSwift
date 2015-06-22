//
//  iOS_GameViewController.swift
//  GameSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import GameCommon

class iOS_GameViewController: iOS_CustomViewController {

    var gameController: GameController!
    var stageView: iOS_StageView?
    var infoAlertController: UIAlertController?

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameController.startGame()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        stageView?.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
        gameController.stopGame()
        MPCController.sharedMPCController.delegate = nil

        super.viewWillDisappear(animated)
    }
    func deviceOrientationDidChange(notification: NSNotification) {
        stageView?.setUpGestureRecognizersDirection()
        drawViews()
    }

}

extension iOS_GameViewController: GameViewController {

    func setUpView() {

        stageView = iOS_StageView()
        stageView?.becomeFirstResponder()
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

        let peer  = MPCController.sharedMPCController.peerID
        let playerLeftGame = MPCMessage.getPeerDidNotConnectMessage(peer)
        MPCController.sharedMPCController.sendMessage(playerLeftGame)

        super.backNavigation(gestureRecognizer)
    }

    func showCrashedInfoAlertController() {
        infoAlertController = InfoAlertController.getInforAlertController(InfoAlertControllerType.Crashed, parentController: self)

        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(self.infoAlertController!, animated: true, completion: nil)
        }
    }

    func updateCrashedInfoAlertController() {
        if let _ = self.infoAlertController {
            self.infoAlertController?.actions.map() { ($0 as UIAlertAction).enabled = true }
            self.infoAlertController?.view.tintColor = UIColor.blackColor()
            self.infoAlertController?.message = ""
        }
    }

    func showWonInfoAlertController() {
        infoAlertController = InfoAlertController.getInforAlertController(InfoAlertControllerType.Won, parentController: self)

        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(self.infoAlertController!, animated: true, completion: nil)
        }
    }

    func dismissGameViewController() {
        navigationController?.popViewControllerAnimated(true)
        if let previousViewController  = navigationController?.visibleViewController {
            if let gameLobbyViewController = previousViewController as? iOS_GameLobbyViewController {
                gameLobbyViewController.showErrorMessage()
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

    func processPauseOrResume() {
        gameController.processPauseOrResumeGame()
    }
}