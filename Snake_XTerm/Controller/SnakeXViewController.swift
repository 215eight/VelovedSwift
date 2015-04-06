//
//  SnakeXViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/30/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class SnakeXViewController: StageDelegate, StageXViewDelegate {

    // MARK: Properties
    var stageViewTransform: StageXViewTransform!
    var stageView: StageXView!
    
    var stageConfigurator: StageConfigurator!
    var stage: Stage!
    
    var apple: Apple!
    var snake: Snake!
    var snake2: Snake!
    var snake3: Snake!
    
    // MARK: Initializers
    init(){
        startGame()
    }
    
    func startGame() {
        setUpModel()
        setUpView()
        animateStage()
        startCapturingUserInput()
    }
    
    func setUpModel() {
        
        stageConfigurator = StageConfiguratorLevel1(size: stageSize)
        stage = Stage.sharedStage
        stage.configurator = stageConfigurator
        stage.delegate = self
        
        let appleLocations = stage.randomLocations(defaultAppleSize)
        apple = Apple(locations: appleLocations, value: defaultAppleValue)
        apple.delegate = stage
        stage.addElement(apple)
        
        var randDirection = Direction.randomDirection()
        var snakeLocations = stage.randomLocations(5, direction: randDirection)
        snake = Snake(locations: snakeLocations, direction: randDirection)
        snake.delegate = stage
        stage.addElement(snake)
        
        randDirection = Direction.randomDirection()
        snakeLocations = stage.randomLocations(5, direction: randDirection)
        snake2 = Snake(locations: snakeLocations, direction: randDirection)
        snake2.delegate = stage
        stage.addElement(snake2)
        
        randDirection = Direction.randomDirection()
        snakeLocations = stage.randomLocations(5, direction: randDirection)
        snake3 = Snake(locations: snakeLocations, direction: randDirection)
        snake3.delegate = stage
        stage.addElement(snake3)
        
    }
    
    func setUpView() {
        
        stageViewTransform = StageXViewTransform(stageSize: stageSize)
        stageView = StageXView(viewTransform: stageViewTransform)
        stageView.delegate = self
        drawViews()
    }
    
    func drawViews() {
        stageView.drawElements(Obstacle.className(), inStage: stage)
    }
    
    func animateStage() {
        stage.animate()
    }
    
    func startCapturingUserInput() {
        stageView.startCapturingInput()
    }
    
    func stopGame() {
        destroyModel()
        destroyView()
    }
    
    func stopCapturingUserInput() {
        stageView.startCapturingInput()
    }
    
    func destroyModel() {
        stage.destroy()
        stage = nil
        stageConfigurator = nil
    }
    
    func destroyView() {
        
        stageView.destroy()
        stageView = nil
        stageConfigurator = nil
    }
    
    func restartGame() {
        stopGame()
        startGame()
    }
    
    // MARK: StageDelegate methods
    
    func elementLocationDidChange(element: StageElement, inStage stage: Stage) {
        drawViews()
        
        let elementType = element.dynamicType.className()
        if elementType == Snake.className() {
            var snake = element as Snake
            if stage.didSnakeCrash(snake) || stage.didSnakeEatItself(snake) {
                
                snake.kill()
                
                if stage.snakesAlive() == 1 {
                    // FIXME: Stops main thread and stop overall execution
                    stageView.stopCapturingInput()
                    self.restartGame()
                }
                
            }else {
                if let apple = stage.didSnakeEatAnApple(snake) {
                    apple.wasEaten()
                    snake.didEatApple()
                }
            }
        }
    }
    
    // MARK: StageXViewDelegate methods
    
    func interpretKey(key: Int32) {
        
        // FIXME: This representation is not correct. Character "A" can be interpreted as up arrow
        switch key{
        case 66: // Down
            mvaddstr(2, 2, "\(key)")
            snake.direction = self.stageViewTransform.getDirection(.Down)
        case 65: // Up
            mvaddstr(2, 2, "\(key)")
            snake.direction = self.stageViewTransform.getDirection(.Up)
        case 67: //Right
            mvaddstr(2, 2, "\(key)")
            snake.direction = self.stageViewTransform.getDirection(.Right)
        case 68: // Left
            mvaddstr(2, 2, "\(key)")
            snake.direction = self.stageViewTransform.getDirection(.Left)
        case 104: //h
            mvaddstr(2, 2, "\(key)")
            snake2.direction = self.stageViewTransform.getDirection(.Left)
        case 106: //j
            mvaddstr(2, 2, "\(key)")
            snake2.direction = self.stageViewTransform.getDirection(.Down)
        case 107: //k
            snake2.direction = self.stageViewTransform.getDirection(.Up)
        case 108:
            snake2.direction = self.stageViewTransform.getDirection(.Right)
        case 97:
            snake3.direction = self.stageViewTransform.getDirection(.Left)
        case 100:
            snake3.direction = self.stageViewTransform.getDirection(.Right)
        case 119:
            snake3.direction = self.stageViewTransform.getDirection(.Up)
        case 115:
            snake3.direction = self.stageViewTransform.getDirection(.Down)
        case Int32(charUnicodeValue("q")):
            exit(0)
        default:
            mvaddstr(2, 2, "\(key)")
            break
        }
        
    }

}
