//
//  OSX_SankeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/7/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit

class OSX_SnakeViewController: NSViewController {

    var snakeGameController: SnakeGameController!
    var stageView: OSX_StageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = OSX_WindowResizer.resizeWindowProportionalToScreenResolution(0.5)!

        snakeGameController = SnakeGameController(viewController: self)
        snakeGameController.startGame()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }
}

extension OSX_SnakeViewController: SnakeViewContoller {
    
    func setUpView() {
        stageView = OSX_StageView(frame: view.bounds)
        stageView.becomeFirstResponder()
        stageView.delegate = self
        view.addSubview(stageView)
        drawViews()
    }

    func drawViews() {
        for (_, elementCollection) in snakeGameController.stage.elements {
            for element in elementCollection {
                stageView.drawElement(element)
            }
        }
    }

    func drawElement(element: StageElement) {
        dispatch_async(dispatch_get_main_queue()) {
            self.stageView.drawElement(element)
        }
    }

    func destroy() {
        stageView.resignFirstResponder()
        stageView.delegate = nil
        stageView.removeFromSuperview()
        stageView = nil
    }
}


extension OSX_SnakeViewController: KeyInputViewDelegate {
    func processKeyInput(key: String, transform: StageViewTransform) {
        snakeGameController.processKeyInput(key, transform: transform)
    }
}
