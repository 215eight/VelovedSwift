//
//  MPCController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import MultipeerConnectivity

private let kServiceID = "partyland-Game"
private let kInviteTimeout: NSTimeInterval = 60.0 //secs
private var _sharedMPCController: MPCController? = MPCController()

public enum MPCControllerMode {
    case Browsing
    case Advertising
}

public enum MPCPeerIDStatus: Printable {
    case Initialized
    case Hosting
    case Browsing
    case Found
    case Accepting
    case Joining
    case Connecting
    case Connected

    public var description: String {
        switch self {
        case .Initialized:
            return "Initialized"
        case .Hosting:
            return "Hosting"
        case .Browsing:
            return "Browsing"
        case .Found:
            return "Found"
        case .Accepting:
            return "Accepting"
        case .Joining:
            return "Joining"
        case .Connecting:
            return "Connecting"
        case .Connected:
            return "Connected"
        }
    }
}

public protocol MPCControllerDelegate: class {
    func didUpdatePeers()
    func didReceiveMessage(message: MPCMessage)
}

public class MPCController: NSObject {

    var peerController: MPCPeerController!
    var session: MCSession!
    var mode: MPCControllerMode?
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!


    weak public var delegate: MPCControllerDelegate?

    public class var sharedMPCController: MPCController {
        if let _ = _sharedMPCController {
            return _sharedMPCController!
        } else {
            _sharedMPCController = MPCController()
            return _sharedMPCController!
        }
    }

    public var precedence: Int {
        var turn = 0
        for peer in getConnectedPeers() {
            if peerID.hash > peer.hash {
                turn++
            }
        }
        return turn
    }

    public class func destroySharedMPCController() {

        _sharedMPCController?.peerController.removeAllPeers()
        _sharedMPCController?.peerController.delegate = nil
        _sharedMPCController?.session.delegate = nil
        _sharedMPCController?.advertiser.delegate = nil
        _sharedMPCController?.browser.delegate = nil
        _sharedMPCController = nil
    }

    public var peerID: MCPeerID {
        return peerController.peerID
    }

    public var peers: Dictionary<MCPeerID, MPCPeerIDStatus> {
        return peerController.peers
    }

    override init() {

        peerController = MPCPeerController()
        session = MCSession(peer: peerController.peerID)
        browser = MCNearbyServiceBrowser(peer: peerController.peerID, serviceType: kServiceID)
        advertiser = MCNearbyServiceAdvertiser(peer: peerController.peerID, discoveryInfo: nil, serviceType: kServiceID)

        super.init()

        peerController.delegate = self
        session.delegate = self
        browser.delegate = self
        advertiser.delegate = self

    }

    public func startBrowsing() {
        if mode != .Browsing {
            stopAdvertising()
            mode = .Browsing
            peerController.setBrowsingMode()
            browser.startBrowsingForPeers()
            println("MPCController started browsing")
        } else {
            println("MPCController is already Browsing")
        }
    }

    public func stopBrowsing() {
        if mode == .Browsing {
            mode = nil
            peerController.resetMode()
            browser.stopBrowsingForPeers()
            println("MPCController stopped browsing")
        } else if mode != nil{
            println("MPCController can't stop browsing because it was not browsing")
        }
    }

    public func startAdvertising() {
        if mode != .Advertising {
            stopBrowsing()
            mode = .Advertising
            peerController.setAdvertisingMode()
            advertiser.startAdvertisingPeer()
            println("MPCController started hosting")
        } else {
            println("MPCController is already Hosting")
        }
    }

    public func stopAdvertising() {
        if mode == .Advertising {
            mode = nil
            peerController.resetMode()
            advertiser.stopAdvertisingPeer()
            println("MPCController stopped hosting")
        } else if mode != nil {
            println("MPCController can't stop hosting becuase it was not hosting")
        }
    }

    public func getConnectedPeers() -> [MCPeerID] {
        return session.connectedPeers as [MCPeerID]
    }

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

extension MPCController: MPCPeerControllerDelegate {

    func didUpdatePeers() {
        delegate?.didUpdatePeers()
    }
}

extension MPCController: MCNearbyServiceBrowserDelegate {

    public func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        peerController.peerWasFound(peerID)
    }

    public func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        peerController.peerWasLost(peerID)
    }

    public func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error.localizedDescription)
    }
}

extension MPCController: MCNearbyServiceAdvertiserDelegate {

    public func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
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
            peerController.peerIsConnecting(peerID)

        case .Connected:
            peerController.peerDidConnect(peerID)

        case .NotConnected:
            peerController.peerDidNotConnect(peerID)
        }
    }

    public func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        if let msg = MPCMessage.deserialize(data){
            delegate?.didReceiveMessage(msg)
        }
    }

    public func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {

    }

    public func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {

    }

    public func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {

    }
}