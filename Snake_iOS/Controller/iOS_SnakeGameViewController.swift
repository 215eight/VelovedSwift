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

        switch gameMode {
        case .SinglePlayer:
            snakeGameController = SinglePlayerSnakeGameController(viewController: self)
        case .MultiPlayerMaster:
            snakeGameController = MultiplayerMasterSnakeGameController(viewController: self)
            MPCController.sharedMPCController.delegate = snakeGameController as MultiplayerSnakeGameController
        case .MultiplayerSlave:
            snakeGameController = MultiplayerSlaveSnakeGameController(viewController: self)
            MPCController.sharedMPCController.delegate = snakeGameController as MultiplayerSnakeGameController
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

    func showModalMessage(){
        stageView.showModalMessage()
    }
}

extension iOS_SnakeGameViewController: InputViewDelegate {

    func processKeyInput(key: String, transform: StageViewTransform) {
        snakeGameController.processKeyInput(key, transform: transform)
    }

    func processSwipe(direction: Direction) {
        if let snakes = snakeGameController.stage.elements[Snake.elementName] as? [Snake] {
            snakes.map( { $0.direction = Direction.Right } )
        }
    }
}