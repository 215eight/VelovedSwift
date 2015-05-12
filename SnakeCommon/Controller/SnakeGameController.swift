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
    func showModalMessage()
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
    var appleMap: [String : Apple]!
    var snakeMap: [String : Snake]!

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
        destroyModel()
        dispatch_async(dispatch_get_main_queue()) {
            self.destroyView()
            self.startGame()
        }
    }

    public func setUpApples(appleConfigMap: [String : AppleConfiguration]) {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    public func setUpSnakes(snakeConfigMap: [String : SnakeConfiguration]) {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    public func scheduleGameStart(gameStartDate: String) {
        assertionFailure("This is an abstract method that must be override by a subclass")
    }

    public func updateRemoteSnakeDirection(peerName: String, newDirection: Direction) {
        let snake = snakeMap[peerName]
        snake?.direction = newDirection
    }

    public func updateRemoteAppleLocations(appleUUID: String, locations: [StageLocation]) {
        let apple = appleMap[appleUUID]
        apple?.updateLocation(locations)
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