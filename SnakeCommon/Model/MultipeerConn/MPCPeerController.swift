//
//  MPCPeerController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/18/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MPCPeerController: NSObject {

    private let kPeerIDKey = "peerIDKey"
    private let kDefaultHostName = "UnknowHostName"

    var peerID: MCPeerID
    var peers = [MCPeerID : MPCPeerIDStatus]()
    private var mode: MPCPeerControllerMode?

    override init() {

        #if os(iOS)
            if let peerIDData = NSUserDefaults.standardUserDefaults().dataForKey(kPeerIDKey) {
                self.peerID = NSKeyedUnarchiver.unarchiveObjectWithData(peerIDData) as MCPeerID
            } else {
                self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
                let peerIDData = NSKeyedArchiver.archivedDataWithRootObject(self.peerID)
                NSUserDefaults.standardUserDefaults().setObject(peerIDData, forKey: kPeerIDKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        #elseif os(OSX)
            var displayName: String

            let pid = NSProcessInfo.processInfo().processIdentifier
            if let hostname = NSHost.currentHost().name {
                displayName = String(format: "%@-%d", arguments: [hostname, pid])
            } else {
                displayName = String(format: "%@-%d", arguments: [kDefaultHostName, pid])
            }

            self.peerID = MCPeerID(displayName: displayName)
        #endif

        super.init()

        peers[self.peerID] = MPCPeerIDStatus.Initialized
    }

    func setBrowsingMode() {
        mode = nil
        mode = MPCPeerControllerBrowsingMode(peerController: self)
    }

    func setAdvertisingMode() {
        mode = nil
        mode = MPCPeerConrollerAdvertisingMode(peerController: self)
    }

}


class MPCPeerControllerMode: NSObject {

    var peerController: MPCPeerController

    init(peerController: MPCPeerController) {
        self.peerController = peerController
        super.init()
    }

    deinit {
        peerController.peers.removeAll(keepCapacity: false)
    }

    func peerWasFound(aPeer: MCPeerID) {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    func peerWasLost(aPeer: MCPeerID) {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    func peerWasInvited(aPeer: MCPeerID) {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    func peerDidReceiveInvitation(aPeer: MCPeerID) {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    func peerIsConnecting(aPeer: MCPeerID) {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    func peerDidConnect(aPeer: MCPeerID) {
        if let peerStatus = peerController.peers[aPeer] {
            assert(peerStatus == MPCPeerIDStatus.Connecting, "Current state \(peerStatus) is invalid to transition to Connected")
            peerController.peers[aPeer] = MPCPeerIDStatus.Connected
            peerController.peers[peerController.peerID] = MPCPeerIDStatus.Connected
        } else {
            peerController.peers[aPeer] = MPCPeerIDStatus.Connected
            peerController.peers[peerController.peerID] = MPCPeerIDStatus.Connected
        }
    }

    func peerDidNotConnect(aPeer: MCPeerID) {
        if let peerStatus = peerController.peers[aPeer] {
            peerController.peers.removeValueForKey(aPeer)
        } else {
            assertionFailure("Trying to remove a nonexisten peer")
        }
    }

}

class MPCPeerControllerBrowsingMode: MPCPeerControllerMode {

    override init(peerController: MPCPeerController) {
        super.init(peerController: peerController)
        peerController.peers[peerController.peerID] = MPCPeerIDStatus.Browsing

        assert(peerController.peers.count == 1, "Only the instance peerID should exist")
    }

    override func peerWasFound(aPeer: MCPeerID) {
        assert(peerController.peers[aPeer] == nil, "Peer should not already exist")

        peerController.peers[aPeer] = MPCPeerIDStatus.Found
    }

    override func peerWasLost(aPeer: MCPeerID) {
        if let _ = peerController.peers[aPeer] {
            peerController.peers.removeValueForKey(aPeer)
        } else {
            assertionFailure("Trying to remove a nonexistent peer")
        }
    }

    override func peerWasInvited(aPeer: MCPeerID) {
        if let peerStatus = peerController.peers[aPeer] {
            assert(peerStatus == MPCPeerIDStatus.Found, "To invite a peer it must be on Found status")
            peerController.peers[aPeer] = MPCPeerIDStatus.Joining
            peerController.peers[peerController.peerID] = MPCPeerIDStatus.Accepting
        } else {
            assertionFailure("Inviting nonexisting peer")
        }
    }

    override func peerDidReceiveInvitation(aPeer: MCPeerID) {
        // This method does nothing on browsing mode
    }

    override func peerIsConnecting(aPeer: MCPeerID) {
        if let peerStatus = peerController.peers[aPeer] {
            assert(peerStatus == MPCPeerIDStatus.Accepting, "Current state \(peerStatus) is an invalid to transition to Connecting")
            peerController.peers[aPeer] = MPCPeerIDStatus.Connecting
            peerController.peers[peerController.peerID] = MPCPeerIDStatus.Connecting
        } else {
            assertionFailure("Connecting a nonexisting peer")
        }
    }

    override func peerDidNotConnect(aPeer: MCPeerID) {
        super.peerDidNotConnect(aPeer)

        if peerController.peers.count == 1 {
            peerController.peers[peerController.peerID] = MPCPeerIDStatus.Browsing
        }
    }

}

class MPCPeerConrollerAdvertisingMode: MPCPeerControllerMode {

    override init(peerController: MPCPeerController) {
        super.init(peerController: peerController)
        peerController.peers[peerController.peerID] = MPCPeerIDStatus.Hosting

        assert(peerController.peers.count == 1, "Only the instance peerID should exist")
    }

    override func peerWasFound(aPeer: MCPeerID) {
        // This method does nothing on advertising mode
    }

    override func peerWasLost(aPeer: MCPeerID) {
        // This method does nothing on advertising mode
    }

    override func peerWasInvited(aPeer: MCPeerID) {
        // This method does nothing on advertising mode
    }

    override func peerDidReceiveInvitation(aPeer: MCPeerID) {
        if let _ = peerController.peers[aPeer] {
            assertionFailure("Invitation received for an already existing peer")
        } else {
            peerController.peers[aPeer] = MPCPeerIDStatus.Joining
            peerController.peers[peerController.peerID] = MPCPeerIDStatus.Accepting
        }
    }

    override func peerIsConnecting(aPeer: MCPeerID) {
        if let peerStatus = peerController.peers[aPeer] {
            assert(peerStatus == MPCPeerIDStatus.Joining, "Current state \(peerStatus) is an invalid transition to Connecting")
            peerController.peers[aPeer] = MPCPeerIDStatus.Connecting
            peerController.peers[peerController.peerID] = MPCPeerIDStatus.Connecting
        } else {
            assertionFailure("Connecting to a nonexisting peer")
        }
    }

    override func peerDidNotConnect(aPeer: MCPeerID) {
        super.peerDidNotConnect(aPeer)

        if peerController.peers.count == 1 {
            peerController.peers[peerController.peerID] = MPCPeerIDStatus.Hosting
        }
    }
}