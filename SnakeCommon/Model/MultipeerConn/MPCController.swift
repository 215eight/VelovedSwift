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
    case Found
    case Invited
}

public protocol MPCControllerDelegate: class {
    func didReceiveMessage(msg: MPCMessage)
}

public class MPCController: NSObject {

    private let kPeerIDKey = "peerIDKey"
    private let kDefaultHostName = "UnknowHostName"

    public var peerID : MCPeerID
    var session: MCSession!
    var mode: MPCControllerMode?
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!

    var peers = [MCPeerID : MPCPeerIDStatus]()
    var foundPeers = [MCPeerID]()
    var peerInvites = [PeerInvite]()

    public var delegate: MPCControllerDelegate?

    public class var sharedMPCController: MPCController {
        return _sharedMPCController
    }

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

        session = MCSession(peer: peerID)

        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: kServiceID)

        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: kServiceID)

        super.init()

        session.delegate = self
        browser.delegate = self
        advertiser.delegate = self

        peers[self.peerID] = MPCPeerIDStatus.Initialized

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

    func addFoundPeer(aPeer: MCPeerID) {
        if dequeueReusablePeerID(aPeer) === aPeer {
            foundPeers.append(aPeer)

            NSNotificationCenter.defaultCenter().postNotificationName(MPCFoundPeersDidChangeNotification,
                object: self,
                userInfo: nil)
        }
    }

    func removeFoundPeer(aPeer: MCPeerID) {
        var foundPeer = false
        for (index, _aPeer) in enumerate(foundPeers) {
            if aPeer.displayName == _aPeer.displayName {
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

    public func getPeerInvites() -> [PeerInvite] {
        return peerInvites
    }

    func addPeerInvite(peerID: MCPeerID) {
        var foundPeer = false
        for aPeerInvite in peerInvites {
            if aPeerInvite.peerID.displayName == peerID.displayName {
                foundPeer = true
                break
            }
        }

        if (!foundPeer) {
            let peerInvite = PeerInvite(peerID: peerID, status: .Pending)
            peerInvites.append(peerInvite)

            NSNotificationCenter.defaultCenter().postNotificationName(MPCPeerInvitesDidChangeNotification,
                object: self,
                userInfo: nil)
        }
    }

    func updatePeerInvite(peerID: MCPeerID, withStatus status: PeerInviteStatus) {
        var foundPeer = false
        for aPeerInvite in peerInvites {
            if aPeerInvite.peerID.displayName == peerID.displayName {
                foundPeer = true
                aPeerInvite.status = status
            }
        }

        if (!foundPeer) {
            addPeerInvite(peerID)
            updatePeerInvite(peerID, withStatus: status)
        }

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

    public func invitePeerWithName(displayName: String?) {
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

    public func getConnectedPeers() -> [MCPeerID] {
        return session.connectedPeers as [MCPeerID]
    }


    // ----------

    public func inivitePeer(aPeer: MCPeerID) {

        if let _ = peers[aPeer] {
            peers[aPeer] = MPCPeerIDStatus.Invited
            browser.invitePeer(aPeer,
                toSession: session,
                withContext: nil,
                timeout: kInviteTimeout)
        } else {
            assertionFailure("Trying to invite an nonexistent peer")
        }
    }
}

extension MPCController: MCNearbyServiceBrowserDelegate {

    public func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        println("Browser \(browser) found a peer \(peerID.displayName)")
        peers[peerID] = MPCPeerIDStatus.Found
    }

    public func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        println("Browser \(browser) removing found peer \(peerID.displayName)")
        peers.removeValueForKey(peerID)
    }

    public func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error.localizedDescription)
    }
}

extension MPCController: MCNearbyServiceAdvertiserDelegate {

    public func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        println("\(browser) received invitation from peer \(peerID.displayName)")
        addPeerInvite(self.peerID)
        addPeerInvite(peerID)
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