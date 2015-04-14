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
    var debuggerView: DebuggerConsoleView!

    override func loadView() {
        snakeGameController = SnakeGameController(viewController: self)
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        keyInputView.becomeFirstResponder()
        keyInputView.delegate = self
        snakeGameController.startGame()

        let aFrame = CGRect(x: 500, y: 200, width: 10, height: 10)
        let aView = NSView(frame: aFrame)
        aView.wantsLayer = true
        aView.layer?.backgroundColor = NSColor.blackColor().CGColor
        self.view.addSubview(aView)
    }
    
}

extension OSX_SnakeViewController: SnakeViewContoller {
    
    func setUpView() {
        //debuggerView = DebuggerConsoleView(cols: DefaultStageSize.width, rows: DefaultStageSize.height)
        //drawViews()
    }

    func drawViews() {
        for (_, elementCollection) in snakeGameController.stage.elements {
            for element in elementCollection {
                debuggerView?.updateElment(element)
            }
        }
        //println(debuggerView?.description)
    }

    func drawElement(element: StageElement) {
        debuggerView?.updateElment(element)
        //println(debuggerView?.description)
    }
}


extension OSX_SnakeViewController: KeyInputViewDelegate {
    func processKeyInput(key: String) {
        snakeGameController.processKeyInput(key)
    }
}
