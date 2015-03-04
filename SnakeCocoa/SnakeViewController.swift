//
//  SnakeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SnakeViewController: UIViewController {

    @IBOutlet var stageView: StageView!
    @IBOutlet weak var snakeView: SnakeView!
    var appleView: AppleView!
    
    var appleRadius: CGFloat = 5.0
    var snakeWidth: CGFloat = 10.0
    
    var animationTimer : NSTimer!
    var animationTimerInterval: NSTimeInterval = 0.5
    var animationDelta = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the stage grid unit size and get linear scaled dimensions
        // TODO: Check what happens if the orientation is not portrait
        stageView.gridUnitSize = 10.0
        
        let xLowerBound: Float = 0
        let yLowerBound: Float = 0
        let xUpperBound: Float = Float(stageView.scaledWidth)
        let yUpperBound: Float = Float(stageView.scaledHeight)
        
        //Create an apple
        let apple = Apple(xLowerBound: xLowerBound + 0.5, xUpperBound: xUpperBound - 0.5, yLowerBound: yLowerBound + 0.5, yUpperBound: yUpperBound - 0.5, randomize: false)
        //Create an apple view
        appleView = AppleView(apple: apple, appleRadius: appleRadius)
        appleView.xOffset = stageView.originX
        appleView.yOffset = stageView.originY
        appleView.scaleFactor = stageView.gridUnitSize
        stageView.addSubview(appleView)
        stageView.sendSubviewToBack(appleView)
        
        // Create a snake
        let snake = Snake.createRandomSnake(xLowerBound + 0.5, xUpperBound: xUpperBound - 0.5, yLowerBound: yLowerBound + 0.5, yUpperBound: yUpperBound - 0.5)
        //Configure the snake view
        snakeView.snake = snake
        snakeView.snakeWidth = snakeWidth
        snakeView.scaleFactor = stageView.gridUnitSize
        snakeView.xOffset = stageView.originX
        snakeView.yOffset = stageView.originY
        //snakeView.scaleFactor = scaleFactor
        
        // Schedule animation timer
        //animationTimer = scheduleAnimationTimer()
    }
    
//    func move(timer: NSTimer){
//        snakeView.snake?.move(Direction.down, continuos: false, scaleFactor: 2.0)
//        let collision = CGRectIntersectsRect(snakeView.snakeHeadRect!, appleView.frame)
//        
//        // Check if the snake did eat an apple
//        let didEatApple = CGRectIntersectsRect(snakeView.snakeHeadRect!, appleView.frame)
//        
//        if didEatApple {
//            // Snake should grow
//            snakeView.snake!.grow()
//            
//            // Speed should increase
//            animationTimer.invalidate()
//            animationTimerInterval -= animationDelta
//            animationTimer = scheduleAnimationTimer()
//            
//            // Generate a new apple
//            appleView.apple.updateLocation()
//            appleView.resizeFrame()  // FIXME: Who should be in charge of trigerring this call, controller or delegate?
//            appleView.setNeedsDisplay()
//            
//        }else { // Check for collisions
//            
//        }
//        
//        snakeView.setNeedsDisplay() //FIXME: Who should be in charge of trigerring this call, controller or delegate?
//    }
    
    func scheduleAnimationTimer() -> NSTimer {
        
        // Create timer
        let timer = NSTimer(timeInterval: animationTimerInterval,
            target: self,
            selector: "move:",
            userInfo: nil,
            repeats: true)
        
        // Schedule the timer
        // TODO: Schedule the timer not in the main thread
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        timer.fire()
        
        return timer
    }
}
