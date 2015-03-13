//
//  SnakeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SnakeViewController: UIViewController, SnakeViewDelegate, SnakeDelegate, AppleDelegate {

    
    // MARK: Properties
    
    var gridUnitsize: CGFloat = 10.0
    
    var stageView: StageView!
    var snakeView: SnakeView!
    var appleView: AppleView!
    
    var snake: Snake!
    var apple: Apple!

    
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
        
    }
    
    // MARK: Instance Methods
    
    func startGame() {
    
        // Set up stage
        stageView = StageView(frame: view.bounds, gridUnitSize: gridUnitsize)
        view.addSubview(stageView)
        
        let xLowerBound: Float = 0
        let yLowerBound: Float = 0
        let xUpperBound: Float = Float(stageView.scaledWidth)
        let yUpperBound: Float = Float(stageView.scaledHeight)
        
        // Set up SnakeView
        snakeView = SnakeView(frame: view.bounds,
            bodyPartLogicalSize: 1.0,
            scaleFactor: stageView.scaleFactor,
            viewOffset: stageView.offset)
        snakeView.delegate = self
        view.addSubview(snakeView)
        
        // Set up AppleView
        appleView = AppleView(gridUnits: 1.0,
            gridUnitSize: stageView.scaleFactor,
            viewOffset: stageView.offset)
        view.addSubview(appleView)
        
        // Create a snake
        snake = Snake(xLowerBound: xLowerBound, xUpperBound: xUpperBound, yLowerBound: yLowerBound, yUpperBound: yUpperBound)
        snake.delegate = self
        
        // Create an apple
        apple = Apple(xLowerBound: xLowerBound, xUpperBound: xUpperBound, yLowerBound: yLowerBound, yUpperBound: yUpperBound)
        apple.delegate = self
        appleView.setLocation(apple)
    }
    
    func endGame() {
        
        snake.kill()
        snake = nil
        
        apple.destroy()
        apple = nil
        
        appleView.removeFromSuperview()
        snakeView.removeFromSuperview()
        stageView.removeFromSuperview()
        appleView = nil
        snakeView = nil
        stageView = nil

    }
    
    func restartGame() {
        endGame()
        startGame()
    }
    
    // MARK: SnakeDelegate methods
    
    func snakeDidMove(){
        
        
        // Check if the snake did eat an apple
        let didEatApple = CGRectIntersectsRect(snakeView.snakeHeadRect(snake), appleView.frame)
        
        if didEatApple {
            println("The snake ate an apple")
            
            apple.move()
            snake.grow()
            
        } else { // Check for collisions
        
            var collision : Bool = false
            
            // Border collision
            for border in stageView.stageBorders {
                collision = CGRectIntersectsRect(snakeView.snakeHeadRect(snake), border.frame)
                if collision {
                    snake.kill()
                    break
                }
            }
            
            // Itself collision
            if !collision {
                for bodyPart in snakeView.bodyPartsRects(snake) {
                    collision = CGRectIntersectsRect(snakeView.snakeHeadRect(snake), bodyPart)
                    if collision {
                        snake.kill()
                        break
                    }
                }
            }
            
            if collision {
                restartGame()
            }
        }
        

        snakeView.drawSnake(snake)
   }
    
    // MARK: SnakeViewDelegate methods
    
    func steerSnake(direction: Direction) {
        snake.steer(direction)
    }
    
    
    // MARK: AppleDelegate methods
    func didUpdateLocation(apple: Apple) {
        appleView.setLocation(apple)
    }
}
