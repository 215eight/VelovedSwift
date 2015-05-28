
//
//  OSX_SankeGameViewController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/7/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit
import GameCommon

class OSX_GameViewController: NSViewController {

    var gameController: GameController!
    var stageView: OSX_StageView!
    weak var windowContainer: OSX_MainWindowController?

    init?(gameMode: GameMode) {
        super.init(nibName: "OSX_SnakeGameViewController", bundle: nil)

        switch gameMode {
        case .SinglePlayer:
            gameController = SinglePlayerGameController()
        case .MultiPlayer:
            gameController = MultiplayerGameController()
            MPCController.sharedMPCController.delegate = gameController as MultiplayerGameController
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
        windowContainer?.gameVC = nil
        windowContainer = nil
    }
}

extension OSX_GameViewController: GameViewController {

    func setUpView() {
        stageView = OSX_StageView(frame: view.bounds)
        stageView.becomeFirstResponder()
        stageView.delegate = self
        view.addSubview(stageView)
        drawViews()
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
            self.stageView.drawElement(element)
        }
    }

    func destroy() {
        stageView.resignFirstResponder()
        stageView.delegate = nil
        stageView.removeFromSuperview()
        stageView = nil
    }

    func showModalMessage() {
        stageView.showModalMessage()
    }
}


extension OSX_GameViewController: InputViewDelegate {
    func processKeyInput(key: String, transform: StageViewTransform) {
        gameController.processKeyInput(key, transform: transform)
    }
}