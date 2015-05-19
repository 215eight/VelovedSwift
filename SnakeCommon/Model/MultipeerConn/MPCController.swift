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

public let MPCFoundPeersDidChangeNotification = "MPCFoundPeersDidChangeNotification"
public let MPCPeerInvitesDidChangeNotification = "MPCPeerInvitesDidChangeNotification"
public let MPCDidReceiveMessageNotification = "MPCDidReceiveMessageNotification"

public enum MPCControllerMode {
    case Browsing
    case Advertising
}

enum MPCPeerIDStatus {
    case Initialized
    case Hosting
    case Browsing
    case Found
    case Accepting
    case Joining
    case Connecting
    case Connected
}

public protocol MPCControllerDelegate: class {
    func didReceiveMessage(msg: MPCMessage)
}

public class MPCController: NSObject {

    var peerController: MPCPeerController
    var session: MCSession
    var mode: MPCControllerMode?
    var browser: MCNearbyServiceBrowser
    var advertiser: MCNearbyServiceAdvertiser

    var foundPeers: [MCPeerID] {
        var foundPeers = [MCPeerID]()
        for (peer, status)  in peerController.peers {
            if status == MPCPeerIDStatus.Found {
                foundPeers.append(peer)
            }
        }
        return foundPeers
    }
    var peerInvites = [PeerInvite]()

    public var delegate: MPCControllerDelegate?

    public class var sharedMPCController: MPCController {
        return _sharedMPCController
    }

    public var peerID: MCPeerID {
        return peerController.peerID
    }

    override init() {

        peerController = MPCPeerController()
        session = MCSession(peer: peerController.peerID)
        browser = MCNearbyServiceBrowser(peer: peerController.peerID, serviceType: kServiceID)
        advertiser = MCNearbyServiceAdvertiser(peer: peerController.peerID, discoveryInfo: nil, serviceType: kServiceID)

        super.init()

        session.delegate = self
        browser.delegate = self
        advertiser.delegate = self

    }

    public func setMode(mode: MPCControllerMode) {
        switch mode {
        case .Advertising:
            if self.mode != .Advertising { self.mode = mode }
        case .Browsing:
            if self.mode != .Browsing { self.mode = mode }
        }
    }

    public func getFoundPeers() -> [MCPeerID] {
        return foundPeers
    }

//    func addFoundPeer(aPeer: MCPeerID) {
//        if dequeueReusablePeerID(aPeer) === aPeer {
//            foundPeers.append(aPeer)
//
//            NSNotificationCenter.defaultCenter().postNotificationName(MPCFoundPeersDidChangeNotification,
//                object: self,
//                userInfo: nil)
//        }
//    }
//
//    func removeFoundPeer(aPeer: MCPeerID) {
//        var foundPeer = false
//        for (index, _aPeer) in enumerate(foundPeers) {
//            if aPeer.displayName == _aPeer.displayName {
//                foundPeer = true
//                foundPeers.removeAtIndex(index)
//                break
//            }
//        }
//
//        assert(foundPeer, "Unable to delete unknown peer from collection of peers found")
//
//        NSNotificationCenter.defaultCenter().postNotificationName(MPCFoundPeersDidChangeNotification,
//            object: self,
//            userInfo: nil)
//    }

    public func getPeerInvites() -> [PeerInvite] {
        return peerInvites
    }

//    func addPeerInvite(peerID: MCPeerID) {
//        var foundPeer = false
//        for aPeerInvite in peerInvites {
//            if aPeerInvite.peerID.displayName == peerID.displayName {
//                foundPeer = true
//                break
//            }
//        }
//
//        if (!foundPeer) {
//            let peerInvite = PeerInvite(peerID: peerID, status: .Pending)
//            peerInvites.append(peerInvite)
//
//            NSNotificationCenter.defaultCenter().postNotificationName(MPCPeerInvitesDidChangeNotification,
//                object: self,
//                userInfo: nil)
//        }
//    }
//
//    func updatePeerInvite(peerID: MCPeerID, withStatus status: PeerInviteStatus) {
//        var foundPeer = false
//        for aPeerInvite in peerInvites {
//            if aPeerInvite.peerID.displayName == peerID.displayName {
//                foundPeer = true
//                aPeerInvite.status = status
//            }
//        }
//
//        if (!foundPeer) {
//            addPeerInvite(peerID)
//            updatePeerInvite(peerID, withStatus: status)
//        }
//
//        NSNotificationCenter.defaultCenter().postNotificationName(MPCPeerInvitesDidChangeNotification,
//            object: self,
//            userInfo: nil)
//    }



    func modeValidation(mode: MPCControllerMode) {
        if self.mode == nil {
            assertionFailure("MPCController mode is not set yet")
        }

        if self.mode != mode {
            assertionFailure("MPCController is in an invalid mode to perform the requested operation")
        }
    }

    public func startBrowsing() {
        modeValidation(.Browsing)
        browser.startBrowsingForPeers()
    }

    public func stopBrowsing() {
        modeValidation(.Browsing)
        browser.stopBrowsingForPeers()
    }

    public func startAdvertising() {
        modeValidation(.Advertising)
        advertiser.startAdvertisingPeer()
    }

    public func stopAdvertising() {
        modeValidation(.Advertising)
        advertiser.stopAdvertisingPeer()
    }

//    func dequeueReusablePeerID(aPeer: MCPeerID) -> MCPeerID {
//        for peerID in foundPeers {
//            if aPeer.displayName == peerID.displayName {
//                return peerID
//            }
//        }
//        return aPeer
//    }
//
//    func foundPeerWithName(displayName: String?) -> MCPeerID? {
//        if let peerDisplayName = displayName {
//            for aPeer in foundPeers {
//                if peerDisplayName == aPeer.displayName {
//                    return aPeer
//                }
//            }
//        }
//        return nil
//    }
//
//    public func invitePeerWithName(displayName: String?) {
//        modeValidation(.Browsing)
//        if let aPeer = foundPeerWithName(displayName) {
//            addPeerInvite(self.peerID)
//            addPeerInvite(aPeer)
//            browser.invitePeer(aPeer,
//                toSession: session,
//                withContext: nil,
//                timeout: kInviteTimeout)
//        }
//    }

    public func getConnectedPeers() -> [MCPeerID] {
        return session.connectedPeers as [MCPeerID]
    }

    // ----------

    public func inivitePeer(aPeer: MCPeerID) {

        peerController.peerWasInvited(aPeer)
        browser.invitePeer(aPeer,
            toSession: session,
            withContext: nil,
            timeout: kInviteTimeout)
    }

    public func sendMessage(msg: MPCMessage) {

        var error: NSError?

        let msgData = msg.serialize()
        let success = session.sendData(msgData,
            toPeers: session.connectedPeers,
            withMode: MCSessionSendDataMode.Reliable,
            error: &error)

        if !success {
            println("Error: \(error?.localizedDescription)")
        }
    }
}

extension MPCController: MCNearbyServiceBrowserDelegate {

    public func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        println("Browser \(browser) found a peer \(peerID.displayName)")
        peerController.peerWasFound(peerID)
    }

    public func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        println("Browser \(browser) removing found peer \(peerID.displayName)")
        peerController.peerWasLost(peerID)
    }

    public func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error.localizedDescription)
    }
}

extension MPCController: MCNearbyServiceAdvertiserDelegate {

    public func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        println("\(browser) received invitation from peer \(peerID.displayName)")
        peerController.peerDidReceiveInvitation(peerID)
        invitationHandler(true,session)
    }

    public func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        println(error.localizedDescription)
    }
}

extension MPCController: MCSessionDelegate {

    public func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        switch state {
        case .Connecting:
            println("\(self.peerID.displayName) connecting to peer \(peerID.displayName)")
            peerController.peerIsConnecting(peerID)

        case .Connected:
            println("\(self.peerID.displayName) connected to peer \(peerID.displayName)")
            peerController.peerDidConnect(peerID)

        case .NotConnected:
            println("Session not connected")
            peerController.peerDidNotConnect(peerID)
        }
    }

    public func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        if let msg = MPCMessage.deserialize(data){
            if delegate != nil {
                delegate?.didReceiveMessage(msg)
            }else {
                NSNotificationCenter.defaultCenter().postNotificationName(MPCDidReceiveMessageNotification,
                    object: self,
                    userInfo: ["msg" : msg])
            }
        }
    }

    public func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {

    }

    public func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {

    }

    public func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {

    }
}