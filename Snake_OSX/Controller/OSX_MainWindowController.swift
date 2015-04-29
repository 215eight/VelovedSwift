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
        case SinglePlayerSnakeGameVC
        case MultiplayerMasterSnakeGameVC
        case MultiplayerSlaveSnakeGameVC
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
            gameLobby?.windowContainer = self
            myCurrentViewController = gameLobby
            myCurrentViewController?.title = "Game Lobby"
        case .SinglePlayerSnakeGameVC:
            if snakeGame == nil {
                snakeGame = OSX_SnakeGameViewController(gameMode: SnakeGameMode.SinglePlayer)
            }
            snakeGame?.windowContainer = self
            myCurrentViewController = snakeGame
            myCurrentViewController?.title = "Snake Game"
        case .MultiplayerMasterSnakeGameVC:
            if snakeGame == nil {
                snakeGame = OSX_SnakeGameViewController(gameMode: SnakeGameMode.MultiPlayerMaster)
            }
            snakeGame?.windowContainer = self
            myCurrentViewController = snakeGame
            myCurrentViewController?.title = "Snake Game (Master)"
        case .MultiplayerSlaveSnakeGameVC:
            if snakeGame == nil {
                snakeGame = OSX_SnakeGameViewController(gameMode: SnakeGameMode.MultiplayerSlave)
            }
            snakeGame?.windowContainer = self
            myCurrentViewController = snakeGame
            myCurrentViewController?.title = "Snake Game (Slave)"
        }

        myTargetView.addSubview(myCurrentViewController!.view)
        myCurrentViewController?.view.frame = myTargetView.bounds
    }

    @IBAction func viewChoicePopUpAction(sender: NSPopUpButton) {
        let viewController = ViewControllerType(rawValue: sender.selectedTag())
        changeViewController(viewController!)
    }

    func showMultiplayerMasterSnakeGameVC() {
        changeViewController(ViewControllerType.MultiplayerMasterSnakeGameVC)
    }

    func showMultiplayerSlaveSnakeGameVC() {
        changeViewController(ViewControllerType.MultiplayerSlaveSnakeGameVC)
    }
}
