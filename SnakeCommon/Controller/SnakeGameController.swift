//
//  SnakeGameController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/9/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//
import Foundation

public protocol SnakeViewController {
    func setUpView()
    func drawElement(element: StageElement)
    func destroy()
}

public enum SnakeGameMode {
    case SinglePlayer
    case MultiPlayerMaster
    case MultiplayerSlave
}

public class SnakeGameController {

    var viewController: SnakeViewController!

    public var stage: Stage!
    var snakeController: SnakeController!

    public init(viewController: SnakeViewController) {
        self.viewController = viewController
    }

    public func startGame() {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    public func setUpModel() {
        assertionFailure("This is an absract method that must be overridden by a subclass")
    }

    func setUpView() {
        viewController.setUpView()
    }

    func animateStage() {
        stage.animate()
    }

    func stopGame() {
        destroyModel()
        destroyView()
    }

    public func destroyModel() {
        stage.destroy()
        stage = nil
    }

    public func destroyView() {
        viewController.destroy()
    }


    func restartGame() {
        dispatch_async(dispatch_get_main_queue()) {
            self.stopGame()
            self.startGame()
        }
    }

    public func setUpSnakes(snakeMap: [String : SnakeConfiguration]) {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    public func scheduleGameStart(gameStartDate: String) {
        assertionFailure("This is an abstract method that must be override by a subclass")
    }
}

extension SnakeGameController {
    public func processKeyInput(key: String, transform: StageViewTransform) {
        if let keyDirection = snakeController.bindings.getDirectionForKey(key) {
            var trxDirection = transform.getDirection(keyDirection)
            snakeController.processKeyInput(key, direction: trxDirection)
        }
    }
}