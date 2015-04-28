//
//  OSX_MainWindowController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/22/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa

class OSX_MainWindowController: NSWindowController {

    @IBOutlet weak var myTargetView: NSView!

    var myCurrentViewController: NSViewController?
    var gameLobby: OSX_GameLobbyViewController?
    var snakeGame: OSX_SnakeGameViewController?

    enum ViewControllerType: Int {
        case GameLobbyVC
        case SnakeGameVC
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        changeViewController(ViewControllerType.GameLobbyVC)
    }

    func changeViewController(viewControllerID: ViewControllerType) {
        myCurrentViewController?.view.removeFromSuperview()

        switch viewControllerID {
        case .GameLobbyVC:
            if gameLobby == nil {
                gameLobby = OSX_GameLobbyViewController(nibName: "OSX_GameLobbyViewController", bundle: nil)
            }
            myCurrentViewController = gameLobby
            myCurrentViewController?.title = "Game Lobby"
        case .SnakeGameVC:
            if snakeGame == nil {
                snakeGame = OSX_SnakeGameViewController(gameMode: SnakeGameMode.SinglePlayer)
            }
            myCurrentViewController = snakeGame
            myCurrentViewController?.title = "Snake Game"
        }

        myTargetView.addSubview(myCurrentViewController!.view)
        myCurrentViewController?.view.frame = myTargetView.bounds
    }

    @IBAction func viewChoicePopUpAction(sender: NSPopUpButton) {
        let viewController = ViewControllerType(rawValue: sender.selectedTag())
        changeViewController(viewController!)
    }
}
