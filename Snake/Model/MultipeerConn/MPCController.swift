//
//  MPCController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import MultipeerConnectivity

private let kServiceID = "partyland-Snake"
private let kInviteTimeout: NSTimeInterval = 60.0 //secs
private let _sharedMPCController = MPCController()

let MPCFoundPeersDidChangeNotification = "MPCFoundPeersDidChangeNotification"
let MPCPeerInvitesDidChangeNotification = "MPCPeerInvitesDidChangeNotification"

enum MPCControllerMode {
    case Browsing
    case Advertising
}

class MPCController: NSObject {

    var peerID: MCPeerID
    var session: MCSession
    var mode: MPCControllerMode?
    var browser: MCNearbyServiceBrowser
    var advertiser: MCNearbyServiceAdvertiser

    var foundPeers = [MCPeerID]()
    var peerInvites = [PeerInvite]()

    class var sharedMPCController: MPCController {
        return _sharedMPCController
    }

    override init() {
        #if os(iOS)
            peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
            #elseif os(OSX)
            peerID = MCPeerID(displayName: NSHost.currentHost().name)
        #endif

        session = MCSession(peer: peerID)

        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: kServiceID)
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: kServiceID)

        super.init()

        session.delegate = self
        browser.delegate = self
        advertiser.delegate = self
    }

    func setMode(mode: MPCControllerMode) {
        switch mode {
        case .Advertising:
            if self.mode != .Advertising { self.mode = mode }
        case .Browsing:
            if self.mode != .Browsing { self.mode = mode }
        }
    }

    func getFoundPeers() -> [MCPeerID] {
        return foundPeers
    }

    func addFoundPeer(aPeer: MCPeerID) {
        if dequeueReusablePeerID(aPeer) === aPeer {
            foundPeers.append(aPeer)
        }

        NSNotificationCenter.defaultCenter().postNotificationName(MPCFoundPeersDidChangeNotification,
            object: self,
            userInfo: nil)
    }

    func removeFoundPeer(aPeer: MCPeerID) {
        var foundPeer = false
        for (index, aPeer) in enumerate(foundPeers) {
            if peerID === aPeer {
                foundPeer = true
                foundPeers.removeAtIndex(index)
                break
            }
        }

        assert(foundPeer, "Unable to delete unknown peer from collection of peers found")

        NSNotificationCenter.defaultCenter().postNotificationName(MPCFoundPeersDidChangeNotification,
            object: self,
            userInfo: nil)
    }

    func getPeerInvites() -> [PeerInvite] {
        return peerInvites
    }

    func addPeerInvite(peerID: MCPeerID) {
        let peerInvite = PeerInvite(peerID: peerID, status: .Pending)
        peerInvites.append(peerInvite)

        NSNotificationCenter.defaultCenter().postNotificationName(MPCPeerInvitesDidChangeNotification,
            object: self,
            userInfo: nil)
    }

    func updatePeerInvite(peerID: MCPeerID, withStatus status: PeerInviteStatus) {
        var foundPeer = false
        for aPeerInvite in peerInvites {
            if aPeerInvite.peerID === peerID {
                foundPeer = true
                aPeerInvite.status = status
            }
        }

        assert(foundPeer, "Unable to update unknown peer with status")

        NSNotificationCenter.defaultCenter().postNotificationName(MPCPeerInvitesDidChangeNotification,
            object: self,
            userInfo: nil)
    }



    func modeValidation(mode: MPCControllerMode) {
        if self.mode == nil {
            assertionFailure("MPCController mode is not set yet")
        }

        if self.mode != mode {
            assertionFailure("MPCController is in an invalid mode to perform the requested operation")
        }
    }

    func startBrowsing() {
        modeValidation(.Browsing)
        browser.startBrowsingForPeers()
    }

    func stopBrowsing() {
        modeValidation(.Browsing)
        browser.stopBrowsingForPeers()
    }

    func startAdvertising() {
        modeValidation(.Advertising)
        advertiser.startAdvertisingPeer()
    }

    func stopAdvertising() {
        modeValidation(.Advertising)
        advertiser.stopAdvertisingPeer()
    }

    func dequeueReusablePeerID(aPeer: MCPeerID) -> MCPeerID {
        for peerID in foundPeers {
            if aPeer.displayName == peerID.displayName {
                return peerID
            }
        }
        return aPeer
    }

    func foundPeerWithName(displayName: String?) -> MCPeerID? {
        if let peerDisplayName = displayName {
            for aPeer in foundPeers {
                if peerDisplayName == aPeer.displayName {
                    return aPeer
                }
            }
        }
        return nil
    }

    func invitePeerWithName(displayName: String?) {
        modeValidation(.Browsing)
        if let aPeer = foundPeerWithName(displayName) {
            addPeerInvite(self.peerID)
            addPeerInvite(aPeer)
            browser.invitePeer(aPeer,
                toSession: session,
                withContext: nil,
                timeout: kInviteTimeout)
        }
   }
}

extension MPCController: MCNearbyServiceBrowserDelegate {

    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        println("Browser \(browser) found a peer \(peerID.displayName)")
        addFoundPeer(peerID)
    }

    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        removeFoundPeer(peerID)
    }

    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error.localizedDescription)
    }
}

extension MPCController: MCNearbyServiceAdvertiserDelegate {

    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        println("\(browser) received invitation from peer \(peerID.displayName)")
        addPeerInvite(self.peerID)
        addPeerInvite(peerID)
        invitationHandler(true,session)
    }

    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        println(error.localizedDescription)
    }
}

extension MPCController: MCSessionDelegate {

    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        switch state {
        case .Connecting:
            println("\(self.peerID.displayName) connecting to peer \(peerID.displayName)")
            updatePeerInvite(self.peerID, withStatus: .Connecting)
            updatePeerInvite(peerID, withStatus: .Connecting)

        case .Connected:
            println("\(self.peerID.displayName) connected to peer \(peerID.displayName)")
            for aPeer in session.connectedPeers as [MCPeerID] {
                updatePeerInvite(aPeer, withStatus: .Connected)
            }
            updatePeerInvite(self.peerID, withStatus: .Connected)
            
        case .NotConnected:
            println("Session not connected")
            // TODO: Decide what to do with not connected peers
            updatePeerInvite(peerID, withStatus: .NotConnected)
        }
    }

    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {

    }

    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {

    }

    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {

    }

    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {

    }
}