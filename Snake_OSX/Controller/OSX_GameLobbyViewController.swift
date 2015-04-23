//
//  OSX_GameLobbyViewController.swift
//  SnakeSwift
//
//  Created by PartyMan on 4/22/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa

class OSX_GameLobbyViewController: NSViewController {

    @IBOutlet weak var advertisingButton: NSButton!
    @IBOutlet weak var foundPeersTableView: NSTableView!
    @IBOutlet weak var peerInvitesTableView: NSTableView!
    var peerInvitesTVC: PeerInvitesTVC!

    var mpcController: MPCController!
    var mode = MPCControllerMode.Advertising

    override func awakeFromNib() {
        initMPCController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        peerInvitesTVC = PeerInvitesTVC(mpcController: mpcController)
        peerInvitesTableView.setDataSource(peerInvitesTVC)
        peerInvitesTableView.setDelegate(peerInvitesTVC)

    }

    func initMPCController() {
        mpcController = MPCController(mode: mode)
        switch mode {
        case .Advertising:
            println("OSX Game Lobby Start Advertising")
            mpcController.startAdvertising()
            mpcController.addObserver(self,
                forKeyPath: "peerInvites",
                options: nil,
                context: nil)

        case .Browsing:
            println("OSX Game Lobby Start Browsing")
            mpcController.startBrowsing()
        }
    }
}

extension OSX_GameLobbyViewController {
    
    @IBAction func toggleAdvertising(sender: NSButton) {
        switch mode {
        case .Advertising:
            mpcController.stopAdvertising()
            mpcController.removeObserver(self, forKeyPath: "peerInvites")
            println("OSX Game Lobby Stop Advertising")
            sleep(2)
            advertisingButton.title = "Start Advertising"
            mode = .Browsing
        case .Browsing:
            mpcController.stopBrowsing()
            println("OSX Game Lobby Stop Browsing")
            advertisingButton.title = "Stop Advertising"
            mode = .Advertising
        }

        initMPCController()
    }

    @IBAction func acceptPeerInvite(sender: NSButton) {
        if peerInvitesTVC.currentSelectedRow >= 0 && peerInvitesTVC.currentSelectedRow <= mpcController.peerInvites.count-1 {
            let peerInvite = mpcController.peerInvites[peerInvitesTVC.currentSelectedRow]
            peerInvite.inviteHandler(true, mpcController.session)
        }
    }
}

extension OSX_GameLobbyViewController {

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if object === mpcController {
            if keyPath == "peerInvites" {
                peerInvitesTableView.reloadData()
            }
        }
    }
}

class PeerInvitesTVC: NSObject {

    var mpcController: MPCController
    var currentSelectedRow = -1

    init(mpcController: MPCController){
        self.mpcController = mpcController
        super.init()
    }

}

extension PeerInvitesTVC: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return mpcController.peerInvites.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let peerInvite = mpcController.peerInvites[row]

        if tableColumn?.identifier == "name" {
            return peerInvite.peerID.displayName
        }else {
            return peerInvite.status.description
        }
    }

}

extension PeerInvitesTVC: NSTableViewDelegate{

    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        currentSelectedRow = row
        return true
    }
}
