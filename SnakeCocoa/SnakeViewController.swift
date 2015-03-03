//
//  SnakeViewController.swift
//  SnakeSwift
//
//  Created by PartyMan on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SnakeViewController: UIViewController {

    @IBOutlet var stageView: StageView!
    @IBOutlet weak var snakeView: SnakeView!
    var appleView: AppleView!
    
    var scaleFactor: CGFloat = 2
    
    var timer : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Create an apple
        let apple = Apple(randomize: false, xUpperBound: 320.0, yUpperBoud: 568.0)
        //Create an apple view
        appleView = AppleView(apple: apple)
        appleView.scaleFactor = scaleFactor
        stageView.addSubview(appleView)
        
        // Create a snake
        let snake = Snake.createRandomSnake(5, xUpperBound: 320.0, yUpperBound: 568.0)
        snake.delegate = snakeView
        //Configure the snake view
        snakeView.snake = snake
        snakeView.scaleFactor = scaleFactor
        
        // Schedule time to move the snake
        timer = NSTimer(timeInterval: 0.5,
            target: self,
            selector: "move:",
            userInfo: nil,
            repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        timer.fire()
    }
    
    func move(timer: NSTimer){
        
        snakeView.snake?.move(Direction.down, continuos: false, scaleFactor: 2.0)
        
    }

    



}
