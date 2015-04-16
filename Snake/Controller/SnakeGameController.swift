//
//  SnakeGameController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/9/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//
import Foundation

protocol SnakeViewContoller {
    func setUpView()
    func drawElement(element: StageElement)
    func destroy()
}

class SnakeGameController: StageDelegate {

    var viewController: SnakeViewContoller!

    var stage: Stage!
    var snakeController: SnakeController!

    init(viewController: SnakeViewContoller) {
        self.viewController = viewController
    }

    func startGame() {
        setUpModel()
        setUpView()
        animateStage()
    }

    func setUpModel() {
        let stageConfigurator = StageConfiguratorLevel1(size: DefaultStageSize)
        stage = Stage.sharedStage
        stage.configurator = stageConfigurator
        stage.delegate = self

        // TODO: Move this to the level configurator
        let appleLocations = stage.randomLocations(DefaultAppleSize)
        let apple = Apple(locations: appleLocations, value: DefaultAppleValue)
        apple.delegate = stage
        stage.addElement(apple)

        let typeGenerator = SnakeTypeGenerator()
        var snakeConfigurator = SnakeConfigurator(stage: stage, bodySize: DefaultSnakeSize, typeGenerator: typeGenerator)
        let keyBindings = KeyboardControlBindings()
        snakeController = SnakeController(bindings: keyBindings)

        while let snake = snakeConfigurator.getSnake() {
            if snakeController.registerSnake(snake) {
                snake.delegate = stage
                stage.addElement(snake)
            }else {
                assertionFailure("Unable to register snake")
            }
        }
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

    func destroyModel() {
        stage.destroy()
        stage = nil
    }

    func destroyView() {
        viewController.destroy()
    }


    func restartGame() {
        stopGame()
        dispatch_async(dispatch_get_main_queue()) {
            self.startGame()
        }
    }

}

extension SnakeGameController: StageDelegate {

    func elementLocationDidChange(element: StageElement, inStage stage: Stage) {
        viewController.drawElement(element)
    }

    func validateGameLogicUsingElement(element: StageElement, inStage stage: Stage) {
        let elementType = element.dynamicType.className()
        if elementType == Snake.className() {
            var snake = element as Snake
            if stage.didSnakeCrash(snake) ||  stage.didSnakeEatItself(snake) {
                snake.kill()
                self.elementLocationDidChange(element, inStage: stage)

                if stage.snakesAlive() == 1 {
                    restartGame()
                }
            }else {
                if let apple = stage.didSnakeEatAnApple(snake) {
                    apple.wasEaten()
                    snake.didEatApple()
                }
            }
        }
    }
}


extension SnakeGameController {
    func processKeyInput(key: String) {
        snakeController.processKeyInput(key)
    }
}