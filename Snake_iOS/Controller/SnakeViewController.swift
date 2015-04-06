//
//  SnakeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import Foundation

class SnakeViewController: UIViewController, StageDelegate {
    
    var rightSGR: UISwipeGestureRecognizer!
    var leftSGR: UISwipeGestureRecognizer!
    var upSGR: UISwipeGestureRecognizer!
    var downSGR: UISwipeGestureRecognizer!
    
    var stageViewTransform: StageViewTransform!
   
    var stageView: StageView!
    
    var stageConfigurator: StageConfigurator!
    var stage: Stage!
    
    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "deviceOrientationDidChange:",
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func loadView() {
        super.loadView()
        setUpGestureRecognizers()
    }
    
    func setUpGestureRecognizers() {
        
        rightSGR = UISwipeGestureRecognizer(target: self, action: "steerSnake:")
        rightSGR.numberOfTouchesRequired = 1
        view.addGestureRecognizer(rightSGR)
        
        leftSGR = UISwipeGestureRecognizer(target: self, action: "steerSnake:")
        leftSGR.numberOfTouchesRequired = 1
        view.addGestureRecognizer(leftSGR)
        
        upSGR = UISwipeGestureRecognizer(target: self, action: "steerSnake:")
        upSGR.numberOfTouchesRequired = 1
        view.addGestureRecognizer(upSGR)
        
        downSGR = UISwipeGestureRecognizer(target: self, action: "steerSnake:")
        downSGR.numberOfTouchesRequired = 1
        view.addGestureRecognizer(downSGR)
    }
    
    func setUpGestureRecognizersDirection() {
        rightSGR.direction = stageViewTransform.getDirection(UISwipeGestureRecognizerDirection.Right)
        leftSGR.direction = stageViewTransform.getDirection(UISwipeGestureRecognizerDirection.Left)
        upSGR.direction = stageViewTransform.getDirection(UISwipeGestureRecognizerDirection.Up)
        downSGR.direction = stageViewTransform.getDirection(UISwipeGestureRecognizerDirection.Down)

    }
    
    func dismantelGestureRecognizers() {
        rightSGR = nil
        leftSGR = nil
        upSGR = nil
        downSGR = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        startGame()
    }
    
    func startGame() {
        setUpModel()
        setUpView()
        setUpGestureRecognizers()
        animateStage()
    }
    func setUpModel() {
        
        stageConfigurator = StageConfiguratorLevel1(size: stageSize)
        stage = Stage.sharedStage
        stage.configurator = stageConfigurator
        stage.delegate = self
       
        // TODO: Move this to the level configurator
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
        
        stageViewTransform = StageViewTransform(frame: view.bounds, stageSize: stageSize)
        stageView = StageView(frame: stageViewTransform.stageFrame, viewTransform: stageViewTransform)
        self.view.addSubview(self.stageView)
        self.drawViews()
        
    }
    
    func animateStage() {
       stage.animate()
    }
    
    func stopGame() {
        destroyModel()
        destroyView()
        dismantelGestureRecognizers()
    }
    
    func destroyModel() {
        stage.destroy()
        stage = nil
        stageConfigurator = nil
    }
    
    func destroyView() {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        stageView = nil
        stageViewTransform = nil
    }

    func restartGame() {
        stopGame()
        startGame()
        setUpGestureRecognizersDirection()
    }
    
    func drawViews() {
        stageView.drawStage()
        stageView.drawElementsInStage(stage)
    }
    
    
    func deviceOrientationDidChange(notification: NSNotification) {
        
        setUpGestureRecognizersDirection()
        drawViews()
    }
    
    // MARK: StageDelegate methods
    func elementLocationDidChange(element: StageElement, inStage stage:Stage) {
        
        if self.stageView != nil {
            dispatch_sync(dispatch_get_main_queue()) {
                self.stageView.drawElement(element)
            }
        }
        
        let elementType = element.dynamicType.className()
        if elementType == Snake.className() {
            var snake = element as Snake
            if stage.didSnakeCrash(snake) || stage.didSnakeEatItself(snake) {
                dispatch_sync(dispatch_get_main_queue()){
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
    
    // MARK: Target methods
    func steerSnake(gestureRecognizer: UIGestureRecognizer) {
        
        if let snakes = stage.elements[Snake.className()] as? [Snake] {
            switch gestureRecognizer {
            case rightSGR:
                snakes.map( { $0.direction = Direction.Right } )
            case leftSGR:
                snakes.map( { $0.direction = Direction.Left } )
            case upSGR:
                snakes.map( { $0.direction = Direction.Up } )
            case downSGR:
                snakes.map( { $0.direction = Direction.Down } )
            default:
                break
            }
            
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue);
    }
    
}