//
//  SnakeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SnakeViewController: UIViewController {
   
    let stageSize = StageSize(width: 32, height: 56)
    var stageViewTransform: StageViewTransform!
    
    var stageView: StageView!
    var snakeView: SnakeView!
    
    var stageConfigurator: StageConfigurator!
    var stage: Stage!
    var apple: Apple!
    var snake: Snake!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "deviceOrientationDidChange:",
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGrayColor()
        setUpModel()
        setUpView()
    }
    
    func setUpModel() {
        
        stageConfigurator = StageConfiguratorLevel1(size: stageSize)
        stage = Stage(configurator: stageConfigurator)
        
        apple = Apple(value: 5)
        apple.delegate = stage
        stage.addElement(apple)
        
        snake = Snake()
        //snake.delegate = self
        stage.addElement(snake)
    }
    
    func setUpView() {
        
        stageViewTransform = StageViewTransform(frame: view.bounds, stageSize: stageSize)
        stageView = StageView(frame: stageViewTransform.stageFrame, viewTransform: stageViewTransform)
        view.addSubview(stageView)
        
    }

    func drawViews() {
        stageView.drawElements(Obstacle.className(), inStage: stage)
        stageView.drawElements(LoopHole.className(), inStage: stage)
        stageView.drawElements(Apple.className(), inStage: stage)
        stageView.drawElements(Snake.className(), inStage: stage)
    }
    
    override func viewDidLayoutSubviews() {
        println("Drawing views")
        drawViews()
    }
    
    func deviceOrientationDidChange(notification: NSNotification) {
        
        let orientation = UIDevice.currentDevice().orientation
        
        stageViewTransform.currentOrientation = orientation
        
        var orientationStr: String
        
        switch orientation {
        case .Portrait:
            orientationStr = "Portrait"
        case .LandscapeRight:
            orientationStr = "LandscapeRight"
        case .LandscapeLeft:
            orientationStr = "LandscapeLeft"
        case .PortraitUpsideDown:
            orientationStr = "PortraitUpsideDown"
        case .FaceDown:
            orientationStr = "FaceDown"
        case .FaceUp:
            orientationStr = "FaceUp"
        case .Unknown:
            orientationStr = "Unknown"
        }
        
        println("Orientation: \(orientationStr)")
        
    }
}