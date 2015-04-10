//
//  SnakeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import Foundation

class iOS_SnakeViewController: UIViewController, StageDelegate, KeyInputViewDelegate {
    
    @IBOutlet var keyInputView: KeyInputView!
    
    var rightSGR: UISwipeGestureRecognizer!
    var leftSGR: UISwipeGestureRecognizer!
    var upSGR: UISwipeGestureRecognizer!
    var downSGR: UISwipeGestureRecognizer!
    
    var stageViewTransform: StageViewTransform!
   
    var stageView: StageView!
    
    var stage: Stage!
    
    var snakeController: SnakeController!
    
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
        
        var direction = stageViewTransform.getDirection(Direction.Right)
        var swipeDirection = UISwipeGestureRecognizerDirection(UInt(direction.rawValue))
        rightSGR.direction = swipeDirection
        
        direction = stageViewTransform.getDirection(Direction.Left)
        swipeDirection = UISwipeGestureRecognizerDirection(UInt(direction.rawValue))
        leftSGR.direction = swipeDirection
        
        direction = stageViewTransform.getDirection(Direction.Up)
        swipeDirection = UISwipeGestureRecognizerDirection(UInt(direction.rawValue))
        upSGR.direction = swipeDirection
        
        direction = stageViewTransform.getDirection(Direction.Down)
        swipeDirection = UISwipeGestureRecognizerDirection(UInt(direction.rawValue))
        downSGR.direction = swipeDirection

    }
    
    func dismantelGestureRecognizers() {
        rightSGR = nil
        leftSGR = nil
        upSGR = nil
        downSGR = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.becomeFirstResponder()
        keyInputView.delegate = self
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
        
        let iOSStageViewTransform = iOS_StageViewTransform()
        stageViewTransform = StageViewTransform(deviceTransform: iOSStageViewTransform)
        stageView = StageView(frame: stageViewTransform.getStageFrame(), viewTransform: stageViewTransform)
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
                
                snake.kill()
                stageView.drawElement(snake)
                
                if stage.snakesAlive() == 1 {
                    dispatch_sync(dispatch_get_main_queue()){
                        self.restartGame()
                    }
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
    
    // MARK: KeyInputViewDelegate methods
    func processKeyInput(key: String) {
        println("Process key \(key)")
        snakeController.processKeyInput(key)
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue);
    }
    
}