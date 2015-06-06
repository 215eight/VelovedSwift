//
//  OSX_MainWindowController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/22/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa
import GameCommon

class OSX_MainWindowController: NSWindowController {

    @IBOutlet weak var myTargetView: NSView!
    @IBOutlet weak var targetViewSelector: NSPopUpButton!

    var myCurrentViewController: NSViewController?
    var gameLobbyVC: OSX_GameLobbyViewController?
    var gameVC: OSX_GameViewController?

    enum ViewControllerType: Int {
        case GameLobbyVC
        case SinglePlayerGameVC
        case MultiplayerGameVC
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        initTargetViewSelector()
        changeViewController(ViewControllerType.GameLobbyVC)
    }

    func initTargetViewSelector() {
        targetViewSelector.addItemWithTitle("Game Lobby")
        targetViewSelector.addItemWithTitle("Game")
        targetViewSelector.selectItemAtIndex(0)
    }

    func changeViewController(viewControllerID: ViewControllerType) {
        myCurrentViewController?.view.removeFromSuperview()

        switch viewControllerID {
        case .GameLobbyVC:
            if gameLobbyVC == nil {
                gameLobbyVC = OSX_GameLobbyViewController(nibName: "OSX_GameLobbyViewController", bundle: nil)
            }
            targetViewSelector.selectItemAtIndex(0)
            gameLobbyVC?.windowContainer = self
            myCurrentViewController = gameLobbyVC
            myCurrentViewController?.title = "Game Lobby"
        case .SinglePlayerGameVC:
            if gameVC == nil {
                gameVC = OSX_GameViewController(gameMode: GameMode.SinglePlayer)
            }
            targetViewSelector.selectItemAtIndex(1)
            gameVC?.windowContainer = self
            myCurrentViewController = gameVC
            myCurrentViewController?.title = "Game"
        case .MultiplayerGameVC:
            if gameVC == nil {
                gameVC = OSX_GameViewController(gameMode: GameMode.MultiPlayer)
            }
            targetViewSelector.selectItemAtIndex(1)
            gameVC?.windowContainer = self
            myCurrentViewController = gameVC
            myCurrentViewController?.title = "Multiplayer Game"
        }

        myTargetView.addSubview(myCurrentViewController!.view)
        myCurrentViewController?.view.frame = myTargetView.bounds
    }

    @IBAction func viewChoicePopUpAction(sender: NSPopUpButton) {
        if let selectedItem = targetViewSelector.selectedItem {
            let selectedIndex = targetViewSelector.indexOfItem(selectedItem)
            let viewController = ViewControllerType(rawValue: selectedIndex)
            changeViewController(viewController!)
        }

    }

    func showMultiplayerGameVC() {
        changeViewController(ViewControllerType.MultiplayerGameVC)
    }

}
