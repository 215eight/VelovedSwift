//
//  iOS_SnakeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import SnakeCommon

class iOS_SnakeGameViewController: UIViewController {

    var snakeGameController: SnakeGameController!
    var stageView: iOS_StageView!

    init(gameMode: SnakeGameMode) {
        super.init(nibName: "iOS_SnakeGameViewController", bundle: nil)

        MPCController.sharedMPCController.delegate = self

        switch gameMode {
        case .SinglePlayer:
            snakeGameController = SinglePlayerSnakeGameController(viewController: self)
        case .MultiPlayerMaster:
            snakeGameController = MultiplayerMasterSnakeGameController(viewController: self)
        case .MultiplayerSlave:
            snakeGameController = MultiplayerSlaveSnakeGameController(viewController: self)
        }

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
        snakeGameController.startGame()
    }

    override func viewDidAppear(animated: Bool) {
        stageView.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
        snakeGameController.destroyView()
        snakeGameController.destroyModel()
    }
    func deviceOrientationDidChange(notification: NSNotification) {
        stageView?.setUpGestureRecognizersDirection()
        drawViews()
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue);
    }

}

extension iOS_SnakeGameViewController: SnakeViewController {

    func setUpView() {

        stageView = iOS_StageView()
        view.addSubview(stageView)
        stageView.becomeFirstResponder()
        stageView.delegate = self

        stageView.setUpGestureRecognizers()

        drawViews()
    }

    func drawViews() {

        dispatch_async(dispatch_get_main_queue()) {
            self.stageView.drawStage()
        }

        for (_, elementCollection) in snakeGameController.stage.elements {
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
        self.stageView.resignFirstResponder()
        stageView.dismantelGestureRecognizers()
        stageView.delegate = nil
        stageView.removeFromSuperview()
        stageView = nil
    }
}

extension iOS_SnakeGameViewController: InputViewDelegate {

    func processKeyInput(key: String, transform: StageViewTransform) {
        snakeGameController.processKeyInput(key, transform: transform)
    }

    func processSwipe(direction: Direction) {
        if let snakes = snakeGameController.stage.elements[Snake.getClassName()] as? [Snake] {
            snakes.map( { $0.direction = Direction.Right } )
        }
    }
}

extension iOS_SnakeGameViewController: MPCControllerDelegate {

    func didReceiveMessage(msg: MPCMessage) {
        switch msg.event {
        case .ScheduleGame:
            scheduleGameStart(msg)
        default:
            break
        }
    }

    func scheduleGameStart(msg: MPCMessage) {
        if let body = msg.body {
            if let gameStartDate = body[MPCMessageKey.GameStartDate] {
                snakeGameController.scheduleGameStart(gameStartDate)
            }
        }
    }
}
