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
    var foundPeersTVC: FoundPeersTVC!

    var mode = MPCControllerMode.Advertising

    override func awakeFromNib() {
        configureMPCController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        foundPeersTVC = FoundPeersTVC()
        foundPeersTableView.setDataSource(foundPeersTVC)

        peerInvitesTVC = PeerInvitesTVC()
        peerInvitesTableView.setDataSource(peerInvitesTVC)
    }

    func configureMPCController() {

        switch mode {
        case .Advertising:
            println("OSX Game Lobby Start Advertising")
            MPCController.sharedMPCController.setMode(mode)
            MPCController.sharedMPCController.startAdvertising()

            registerMPCPeerInvitesDidChangeNotification()

        case .Browsing:
            println("OSX Game Lobby Start Browsing")
            MPCController.sharedMPCController.setMode(mode)
            MPCController.sharedMPCController.startBrowsing()

        }
    }

    override func viewWillDisappear() {
        unregisterMPCPeerInvitesDidChangeNotification()
    }

    func registerMPCPeerInvitesDidChangeNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updatePeerInvites",
            name: MPCPeerInvitesDidChangeNotification,
            object: MPCController.sharedMPCController)
    }

    func unregisterMPCPeerInvitesDidChangeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: MPCPeerInvitesDidChangeNotification,
            object: MPCController.sharedMPCController)
    }
}

extension OSX_GameLobbyViewController {
    
    @IBAction func toggleAdvertising(sender: NSButton) {
        switch mode {
        case .Advertising:
            MPCController.sharedMPCController.stopAdvertising()
            println("OSX Game Lobby Stop Advertising")
            unregisterMPCPeerInvitesDidChangeNotification()

            advertisingButton.title = "Start Advertising"
            mode = .Browsing

        case .Browsing:
            MPCController.sharedMPCController.stopBrowsing()
            println("OSX Game Lobby Stop Browsing")

            advertisingButton.title = "Stop Advertising"
            mode = .Advertising
        }

        configureMPCController()
    }

    func updatePeerInvites() {
        peerInvitesTableView.reloadData()
    }
}

extension OSX_GameLobbyViewController {

}

class PeerInvitesTVC: NSObject {

    override init(){
        super.init()
    }

}

extension PeerInvitesTVC: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return MPCController.sharedMPCController.getPeerInvites().count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let peerInvite = MPCController.sharedMPCController.getPeerInvites()[row]

        if tableColumn?.identifier == "name" {
            return peerInvite.peerID.displayName
        }else {
            return peerInvite.status.description
        }
    }
}

class FoundPeersTVC: NSObject {

}

extension FoundPeersTVC: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return MPCController.sharedMPCController.getFoundPeers().count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let aPeer = MPCController.sharedMPCController.getFoundPeers()[row]
        return aPeer.displayName
    }
}