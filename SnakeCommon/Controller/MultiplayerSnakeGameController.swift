//
//  File.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class MultiplayerSnakeGameController: SnakeGameController {

    override public func startGame() {
        setUpModel()
        setUpView()
        scheduleGame()
    }

    override public func setUpModel() {
        let stageConfigurator = StageConfiguratorLevel1(size: DefaultStageSize)
        stage = Stage.sharedStage
        stage.configurator = stageConfigurator
        stage.delegate = self

        snakeController = SnakeController(bindings: KeyboardControlBindings())

    }

    func scheduleGame() {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    override public func setUpSnakes(snakeMap: [String : SnakeConfiguration]) {
        let snakeConfigurator = SnakeConfigurator(stage: stage)
        snakeConfigurator.configureSnakes(snakeMap, snakeController: snakeController)
    }

    override public func scheduleGameStart(gameStartDate: String) {

        let gameStartDateTimeInterval = (gameStartDate as NSString).doubleValue

        let futureDate = NSDate(timeIntervalSince1970: gameStartDateTimeInterval)

        var futureDateSpec = timespec(tv_sec: Int(futureDate.timeIntervalSince1970), tv_nsec: 0)

        dispatch_after(dispatch_walltime(&futureDateSpec, 0), dispatch_get_main_queue()){
            self.animateStage()
        }
    }
}

extension MultiplayerSnakeGameController: StageDelegate {
    func elementLocationDidChange(element: StageElement, inStage stage: Stage) {
        viewController.drawElement(element)
    }

    func validateGameLogicUsingElement(element: StageElement, inStage stage: Stage) {
        if let snake = element as? Snake {
            if stage.didSnakeCrash(snake) ||  stage.didSnakeEatItself(snake) {
                snake.kill()
                self.elementLocationDidChange(element, inStage: stage)

                if stage.snakesAlive() <= 1 {
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