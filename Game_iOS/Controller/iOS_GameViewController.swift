//
//  iOS_GameViewController.swift
//  GameSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import GameCommon

class iOS_GameViewController: UIViewController {

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

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        stageView?.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
        gameController.stopGame()
    }
    func deviceOrientationDidChange(notification: NSNotification) {
        stageView?.setUpGestureRecognizersDirection()
        drawViews()
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue);
    }

}

extension iOS_GameViewController: GameViewController {

    func setUpView() {

        stageView = iOS_StageView()
        stageView?.becomeFirstResponder()
        stageView?.delegate = self
        view.addSubview(stageView!)
        stageView?.setUpGestureRecognizers()

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

}

extension iOS_GameViewController: InputViewDelegate {

    func processKeyInput(key: String, transform: StageViewTransform) {
        gameController.processKeyInput(key, transform: transform)
    }

    func processSwipe(direction: Direction) {
        if let players = gameController.stage.elements[Player.elementName] as? [Player] {
            players.map( { $0.direction = Direction.Right } )
        }
    }
}