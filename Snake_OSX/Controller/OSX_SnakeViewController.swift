//
//  OSX_SankeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/7/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa

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
    }
    
}

extension OSX_SnakeViewController: SnakeViewContoller {
    
    func setUpView() {
        debuggerView = DebuggerConsoleView(cols: DefaultStageSize.width, rows: DefaultStageSize.height)
        drawViews()
    }

    func drawViews() {
        for (_, elementCollection) in snakeGameController.stage.elements {
            for element in elementCollection {
                debuggerView.updateElment(element)
            }
        }
        println(debuggerView.description)
    }

    func drawElement(element: StageElement) {
        debuggerView.updateElment(element)
        println(debuggerView.description)
    }
}


extension OSX_SnakeViewController: KeyInputViewDelegate {
    func processKeyInput(key: String) {
        snakeGameController.processKeyInput(key)
    }
}
