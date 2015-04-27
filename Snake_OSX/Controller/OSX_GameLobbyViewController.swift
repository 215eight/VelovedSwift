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
        foundPeersTableView.setDelegate(foundPeersTVC)

        peerInvitesTVC = PeerInvitesTVC()
        peerInvitesTableView.setDataSource(peerInvitesTVC)

        registerMPCPeerInvitesDidChangeNotification()
        registerMPCFoundPeersDidChangeNotification()
    }

    func configureMPCController() {

        switch mode {
        case .Advertising:
            println("OSX Game Lobby Start Advertising")
            MPCController.sharedMPCController.setMode(mode)
            MPCController.sharedMPCController.startAdvertising()
        case .Browsing:
            println("OSX Game Lobby Start Browsing")
            MPCController.sharedMPCController.setMode(mode)
            MPCController.sharedMPCController.startBrowsing()
        }
    }

    override func viewWillDisappear() {
        unregisterMPCPeerInvitesDidChangeNotification()
        unregisterMPCFoundPeersDidChangeNotification()
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

    func registerMPCFoundPeersDidChangeNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateFoundPeers",
            name: MPCFoundPeersDidChangeNotification,
            object: MPCController.sharedMPCController)
    }

    func unregisterMPCFoundPeersDidChangeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: MPCFoundPeersDidChangeNotification,
            object: MPCController.sharedMPCController)
    }
}

extension OSX_GameLobbyViewController {
    
    @IBAction func toggleAdvertising(sender: NSButton) {
        switch mode {
        case .Advertising:
            MPCController.sharedMPCController.stopAdvertising()
            println("OSX Game Lobby Stop Advertising")

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

    @IBAction func invitePeer(sender: NSButton) {
        MPCController.sharedMPCController.invitePeerWithName(foundPeersTVC.selectedPeer)
    }

    func updatePeerInvites() {

        dispatch_async(dispatch_get_main_queue()) {
            self.peerInvitesTableView.reloadData()
        }
    }

    func updateFoundPeers() {
        dispatch_async(dispatch_get_main_queue()) {
            self.foundPeersTableView.reloadData()
        }
    }
}

extension OSX_GameLobbyViewController {

}

class PeerInvitesTVC: NSObject {

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
    var selectedPeer: String?
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

extension FoundPeersTVC: NSTableViewDelegate {
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let column = tableView.tableColumns[0] as NSTableColumn
        selectedPeer = self.tableView(tableView, objectValueForTableColumn: column, row: row) as? String
        return true
    }
}