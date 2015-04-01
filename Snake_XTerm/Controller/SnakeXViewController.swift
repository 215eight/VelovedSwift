//
//  SnakeXViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/30/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

class SnakeXViewController {

    // Properties
    var stageViewTransform: StageXViewTransform!
    var stageView: StageXView!
    
    var stageConfigurator: StageConfigurator!
    var stage: Stage!
    
    // Initializers
    init(){
        setUpModel()
        setUpView()
        
        waitForInput()
    }
    
    func setUpModel() {
        
        stageConfigurator = StageConfiguratorLevel1(size: stageSize)
        stage = Stage.sharedStage
        stage.configurator = stageConfigurator
        
        let appleLocations = stage.randomLocations(defaultAppleSize)
        let apple = Apple(locations: appleLocations, value: defaultAppleValue)
        apple.delegate = stage
        stage.addElement(apple)
        
        let randDirection = Direction.randomDirection()
        let snakeLocations = stage.randomLocations(5, direction: randDirection)
        let snake = Snake(locations: snakeLocations, direction: randDirection)
        snake.delegate = stage
        stage.addElement(snake)
        
    }
    
    func setUpView() {
        
        stageViewTransform = StageXViewTransform(stageSize: stageSize)
        stageView = StageXView(viewTransform: stageViewTransform)
        drawViews()
    }
    
    func drawViews() {
        stageView.drawElements(Obstacle.className(), inStage: stage)
    }
    
    func waitForInput() {
        sleep(10)
    }

}
