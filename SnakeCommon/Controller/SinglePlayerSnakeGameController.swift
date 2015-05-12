//
//  SinglePlayerSnakeGameController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

public class SinglePlayerSnakeGameController: SnakeGameController {

    override public func startGame() {
        setUpModel()
        setUpView()
        animateStage()
    }

    override public func setUpModel() {
        let stageConfigurator = StageConfiguratorLevel1(size: DefaultStageSize)
        stage = Stage.sharedStage
        stage.configurator = stageConfigurator
        stage.delegate = self

        // TODO: Move this to the level configurator
        let appleLocations = stage.randomLocations(DefaultAppleSize)
        let apple = Apple(locations: appleLocations, value: DefaultAppleValue)
        apple.delegate = stage
        stage.addElement(apple)

        var snakeConfigurationGenerator = SnakeConfigurationGenerator(stage: stage)
        let snakeConfiguration = snakeConfigurationGenerator.next()!
        snakeConfigurationGenerator.cleanUpStage()

        let snake = Snake(locations: snakeConfiguration.locations,
            direction: snakeConfiguration.direction)
        snake.type = snakeConfiguration.type
        snake.delegate = stage
        stage.addElement(snake)

        snakeController = SnakeController(bindings: KeyboardControlBindings())
        snakeController.registerSnake(snake)

    }

}

extension SinglePlayerSnakeGameController: StageDelegate {

    func elementLocationDidChange(element: StageElement, inStage stage: Stage) {
        viewController.drawElement(element)
    }

    func validateGameLogicUsingElement(element: StageElement, inStage stage: Stage) {
        if let snake = element as? Snake {
            if stage.didSnakeCrash(snake) ||  stage.didSnakeEatItself(snake) {
                snake.kill()
                self.elementLocationDidChange(element, inStage: stage)
                restartGame()
            }else {
                if let apple = stage.didSnakeEatAnApple(snake) {
                    apple.wasEaten()
                    snake.didEatApple()
                }
            }
        }
    }
}