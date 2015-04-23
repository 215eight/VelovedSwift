//
//  iOS_SnakeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import Foundation

class iOS_SnakeViewController: UIViewController {
    
    var snakeGameController: SnakeGameController!
    var stageView: iOS_StageView!

    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "deviceOrientationDidChange:",
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        snakeGameController = SnakeGameController(viewController: self)
        snakeGameController.startGame()
    }

    override func viewDidAppear(animated: Bool) {
        stageView.becomeFirstResponder()
    }

    func deviceOrientationDidChange(notification: NSNotification) {
        stageView?.setUpGestureRecognizersDirection()
        drawViews()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue);
    }
    
}

extension iOS_SnakeViewController: SnakeViewController {

    func setUpView() {

        stageView = iOS_StageView()
        view.addSubview(stageView)
        stageView.becomeFirstResponder()
        stageView.delegate = self

        stageView.setUpGestureRecognizers()

        drawViews()
    }

    func drawViews() {

        dispatch_async(dispatch_get_main_queue()) {
            self.stageView.drawStage()
        }

        for (_, elementCollection) in snakeGameController.stage.elements {
            for element in elementCollection {
                drawElement(element)
            }
        }
    }

    func drawElement(element: StageElement) {
        dispatch_async(dispatch_get_main_queue()) {
            self.stageView.drawElement(element)
        }
    }

    func destroy() {

        dispatch_sync(dispatch_get_main_queue()) {
            let _ = self.stageView.resignFirstResponder()
        }

        stageView.dismantelGestureRecognizers()
        stageView.delegate = nil
        stageView.removeFromSuperview()
        stageView = nil
    }
}

extension iOS_SnakeViewController: InputViewDelegate {
    
    func processKeyInput(key: String, transform: StageViewTransform) {
        snakeGameController.processKeyInput(key, transform: transform)
    }

    func processSwipe(direction: Direction) {
        if let snakes = snakeGameController.stage.elements[Snake.className()] as? [Snake] {
            snakes.map( { $0.direction = Direction.Right } )
        }
    }
}