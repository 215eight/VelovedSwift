//
//  iOS_GameLobbyViewController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import GameCommon
import MultipeerConnectivity

enum GameInvitationStatus {
    case Pending
    case Accepted
}

class iOS_GameLobbyViewController: UIViewController {


    let mainButtonTitleBrowsing = "Join Game"
    let mainButtonTitleAdvertising = "Start Game"

    var mode: MPCControllerMode
    var browsingController: iOS_MPCGameLobbyBrowsingController?

    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet var peerViews: [iOS_PeerView]!

    init(mode: MPCControllerMode) {
        self.mode = mode

        super.init(nibName: "iOS_GameLobbyViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {

        configureMainButton()
        MPCController.sharedMPCController.delegate = self

        switch mode {
        case .Advertising:
            MPCController.sharedMPCController.startAdvertising()
        case .Browsing:
            presentBrowsingPeersController()
        }
    }

    func configureMainButton() {
        switch mode {
        case .Browsing:
            mainButton.setTitle(mainButtonTitleBrowsing, forState: .Normal)
            mainButton.setTitle(mainButtonTitleBrowsing, forState: .Highlighted)
            mainButton.setTitle(mainButtonTitleBrowsing, forState: .Selected)
        case .Advertising:
            mainButton.setTitle(mainButtonTitleAdvertising, forState: .Normal)
            mainButton.setTitle(mainButtonTitleAdvertising, forState: .Highlighted)
            mainButton.setTitle(mainButtonTitleAdvertising, forState: .Selected)
        }
    }

    func presentBrowsingPeersController() {
        browsingController = iOS_MPCGameLobbyBrowsingController()

        presentViewController(browsingController!.alertController, animated: true, completion: {
            MPCController.sharedMPCController.startBrowsing()
        })
    }

    func updatePeerViews() {
        for (peerView) in peerViews {
            peerView.peerNameLabel.text = ""
            peerView.peerStatusLabel.text = ""
        }

        var peerViewGenerator = peerViews.generate()
        for (peer, status) in MPCController.sharedMPCController.peers {
            if status != MPCPeerIDStatus.Found {
                if let peerView = peerViewGenerator.next() {
                    peerView.peerNameLabel.text = peer.displayName
                    peerView.peerStatusLabel.text = status.description
                }
            }
        }
    }
}

extension iOS_GameLobbyViewController: MPCControllerDelegate {

    func didUpdatePeers() {

        dispatch_async(dispatch_get_main_queue()) {
            self.updatePeerViews()

            if let _ = self.browsingController {
                self.browsingController?.updateTextFields()
            }
        }
    }

    func didReceiveMessage(msg: MPCMessage) {
        switch msg.event {
        case .ShowGameViewController:
            MPCController.sharedMPCController.operationMode = .SendAndQueueReceive
            showGameViewController()
        default:
            assertionFailure("Game Lobby received invalid messege")
        }
    }

    func peerIsConnecting(peer: MCPeerID) {
        // Do nothing
    }
    func peerDidConnect(peer: MCPeerID) {
        // Do nothing
    }

    func peerDidNotConnect(peer: MCPeerID) {
        // Do nothing
    }
}

extension iOS_GameLobbyViewController {

    @IBAction func mainButtonAction(sender: UIButton) {
        switch mode {
        case .Browsing:
            presentBrowsingPeersController()
        case .Advertising:

            MPCController.sharedMPCController.stopAdvertising()

            MPCController.sharedMPCController.operationMode = .SendAndQueueReceive
            let showGameViewControllerMsg = MPCMessage.getShowGameViewControllerMessage()
            MPCController.sharedMPCController.sendMessage(showGameViewControllerMsg)
            showGameViewController()
        }
    }

    func showGameViewController() {

        dispatch_async(dispatch_get_main_queue()) {
            let gameVC = iOS_GameViewController(gameMode: GameMode.MultiPlayer)
            self.showViewController(gameVC, sender: self)
        }
    }

}
