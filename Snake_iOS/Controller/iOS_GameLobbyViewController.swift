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
    var mpcController: MPCController
    var browsingPeersController: iOS_MPCFoundPeersController?


    init(mode: MPCControllerMode) {
        self.mode = mode
        mpcController = MPCController(mode: mode)

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
    }

    override func viewWillDisappear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func presentBrowsingPeersController() {
        browsingPeersController = iOS_MPCFoundPeersController(mpcController: mpcController)

        mpcController.addObserver(browsingPeersController!,
            forKeyPath: "foundPeers",
            options: nil,
            context: nil)

        presentViewController(browsingPeersController!.alertController, animated: true, completion: {
            self.mpcController.startBrowsing()
        })
    }

}
