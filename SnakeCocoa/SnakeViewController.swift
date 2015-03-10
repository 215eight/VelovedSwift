//
//  SnakeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SnakeViewController: UIViewController, SnakeViewDelegate, SnakeDelegate {

    
    // MARK: Properties
    
    var gridUnitsize: CGFloat = 10.0
    
    var stageView: StageView!
    var snakeView: SnakeView!
    //var appleView: AppleView!
    
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
    
        
        // Create a snake
        snake = Snake(xLowerBound: xLowerBound, xUpperBound: xUpperBound, yLowerBound: yLowerBound, yUpperBound: yUpperBound)
        snake.delegate = self
        
        // Create an apple
        

    }
    
    func endGame() {
        
        snake = nil
        apple = nil
        
        snakeView.removeFromSuperview()
        stageView.removeFromSuperview()
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
//        let didEatApple = CGRectIntersectsRect(snakeView.snakeHeadRect!, appleView.frame)
//        
//        if didEatApple {
//            println("The snake ate an apple")
//            
//            // Invalidate timers
//            appleRandomTimer.invalidate()
//            animationTimer.invalidate()
//            
//            // Update apple location and schedule its timer
//            updateAppleLocation()
//            appleRandomTimerInterval -= appleRandomTimerDelta
//            scheduleAppleRandomTimer()
//            
//            // Snake updates
//            snakeView.growSnake()
//            snakeView.moveSnake(continuous: false)
//       
//            snakeView.setNeedsDisplay() //FIXME: Who should be in charge of trigerring this call, controller or delegate?
//            animationTimerInterval -= animationDelta
//            scheduleAnimationTimer()
//            
//        } else { // Check for collisions
        
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
//        }
        
        // If the snake didn't eat an appple and there was no collision, just draw it
        snakeView.drawSnake(snake)
   }
    
    // MARK: SnakeViewDelegate methods
    func steerSnake(direction: Direction) {
        snake.steer(direction)
    }
}
