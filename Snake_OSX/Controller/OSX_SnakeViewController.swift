//
//  OSX_SankeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/7/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit

class OSX_SnakeViewController: NSViewController {

    @IBOutlet var keyInputView: OSX_KeyInputView!

    var snakeGameController: SnakeGameController!
    var stageView: OSX_StageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        keyInputView.frame = OSX_WindowResizer.resizeWindowProportionalToScreenResolution(0.5)!
        keyInputView.becomeFirstResponder()
        keyInputView.delegate = self

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
        stageView.removeFromSuperview()
        stageView = nil
    }
}


extension OSX_SnakeViewController: KeyInputViewDelegate {
    func processKeyInput(key: String) {
        snakeGameController.processKeyInput(key)
    }
}
