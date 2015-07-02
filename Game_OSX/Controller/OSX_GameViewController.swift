
//
//  OSX_SankeGameViewController.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/7/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit
import VelovedCommon

class OSX_GameViewController: NSViewController {

    var gameController: GameController!
    var stageView: OSX_StageView?
    weak var windowContainer: OSX_MainWindowController?

    init?(gameMode: GameMode) {
        super.init(nibName: "OSX_GameViewController", bundle: nil)

        switch gameMode {
        case .SinglePlayer:
            gameController = SinglePlayerGameController()
        case .MultiPlayer:
            gameController = MultiplayerGameController()
            MPCController.sharedMPCController.delegate = gameController as MultiplayerGameController
            MPCController.sharedMPCController.operationMode = .SendAndReceive
        }

        gameController.viewController = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.frame = OSX_WindowResizer.resizeWindowProportionalToScreenResolution(0.5)!

        gameController.startGame()
    }

    override func viewWillDisappear() {
        gameController.stopGame()
        MPCController.sharedMPCController.delegate = nil
        windowContainer?.gameVC = nil
        windowContainer = nil

        super.viewWillDisappear()
    }
}

extension OSX_GameViewController: GameViewController {

    func setUpView() {
        self.stageView = OSX_StageView(frame: self.view.bounds)
        self.stageView?.becomeFirstResponder()
        self.stageView?.delegate = self
        self.view.addSubview(self.stageView!)
        self.drawViews()
    }

    func drawViews() {
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
        self.stageView?.resignFirstResponder()
        self.stageView?.delegate = nil
        self.stageView?.removeFromSuperview()
        self.stageView = nil
    }

    func dismissGameViewController(errorCode: GameError) {
//       dismissViewController(self)
    }

    func showCrashedInfoAlertController() {

    }

    func updateCrashedInfoAlertController() {

    }

    func showWonInfoAlertController() {

    }

}


extension OSX_GameViewController: InputViewDelegate {
    func processKeyInput(key: String, transform: StageViewTransform) {
        gameController.processKeyInput(key, transform: transform)
    }

    func processSwipe(direction: Direction) {
        // No swipes on OSX
    }

    func processPauseOrResumeTouch() -> Bool {
        // Feature not implemented
        return false
    }
}