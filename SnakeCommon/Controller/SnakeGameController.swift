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
//        let stageConfigurator = StageConfiguratorLevel1(size: DefaultStageSize)
//        stage = Stage.sharedStage
//        stage.configurator = stageConfigurator
//        stage.delegate = self
//
//        // TODO: Move this to the level configurator
//        let appleLocations = stage.randomLocations(DefaultAppleSize)
//        let apple = Apple(locations: appleLocations, value: DefaultAppleValue)
//        apple.delegate = stage
//        stage.addElement(apple)
//
//        let typeGenerator = SnakeTypeGenerator()
//        var snakeConfigurator = SnakeConfigurator(stage: stage, bodySize: DefaultSnakeSize, typeGenerator: typeGenerator)
//        let keyBindings = KeyboardControlBindings()
//        snakeController = SnakeController(bindings: keyBindings)
//
//        while let snake = snakeConfigurator.getSnake() {
//            if snakeController.registerSnake(snake) {
//                snake.delegate = stage
//                stage.addElement(snake)
//            }else {
//                assertionFailure("Unable to register snake")
//            }
//        }
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

}

extension SnakeGameController {
    public func processKeyInput(key: String, transform: StageViewTransform) {
        if let keyDirection = snakeController.bindings.getDirectionForKey(key) {
            var trxDirection = transform.getDirection(keyDirection)
            snakeController.processKeyInput(key, direction: trxDirection)
        }
    }
}