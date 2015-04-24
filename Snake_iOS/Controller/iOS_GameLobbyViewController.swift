//
//  iOS_GameLobbyViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import MultipeerConnectivity
import UIKit

enum GameInvitationStatus {
    case Pending
    case Accepted
}

class iOS_GameLobbyViewController: UIViewController {

    var mode: MPCControllerMode
    var browsingPeersController: iOS_MPCFoundPeersController?

    @IBOutlet var peerInviteViews: [iOS_PeerInvite]!

    init(mode: MPCControllerMode) {
        self.mode = mode

        super.init(nibName: "iOS_GameLobbyViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        if mode == MPCControllerMode.Browsing {
            presentBrowsingPeersController()
        }

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updatePeerInviteViews",
            name: MPCPeerInvitesDidChangeNotification,
            object: MPCController.sharedMPCController)
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: MPCPeerInvitesDidChangeNotification,
            object: MPCController.sharedMPCController)
    }

    func presentBrowsingPeersController() {
        browsingPeersController = iOS_MPCFoundPeersController()

        presentViewController(browsingPeersController!.alertController, animated: true, completion: {
            MPCController.sharedMPCController.setMode(self.mode)
            MPCController.sharedMPCController.startBrowsing()
        })
    }

    func updatePeerInviteViews() {
        let peerInvites = MPCController.sharedMPCController.getPeerInvites()
        for (index, invite) in enumerate(peerInvites) {
            let peerInviteView = peerInviteViews[index] as iOS_PeerInvite
            peerInviteView.peerNameLabel.text = invite.peerID.displayName
            peerInviteView.statusLabel.text = invite.status.description
        }
    }

}
