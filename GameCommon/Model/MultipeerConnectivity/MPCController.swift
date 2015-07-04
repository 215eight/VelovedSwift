//
//  MPCController.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import MultipeerConnectivity

private let kServiceID = "partyland-Game"
private let kInviteTimeout: NSTimeInterval = 60.0 //secs
private var _sharedMPCController: MPCController?

public enum MPCControllerMode {
    case Browsing
    case Advertising
}

public enum MPCControllerOperationMode {
    case SendAndReceive
    case SendAndQueueReceive
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
    func peerIsConnecting(peer: MCPeerID)
    func peerDidConnect(peer: MCPeerID)
    func peerDidNotConnect(peer: MCPeerID)
}

public class MPCController: NSObject {

    var peerController: MPCPeerController!
    var session: MCSession!
    var mode: MPCControllerMode?
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!

    public var operationMode: MPCControllerOperationMode {
        didSet {
            switch operationMode {
            case .SendAndReceive:
                processAllQueuedMessages()
            case .SendAndQueueReceive:
                assert(messageQueue.isEmpty, "Message queue should be empty")
            }
        }
    }
    var messageQueue = [MPCMessage]()


    weak public var delegate: MPCControllerDelegate?

    public class var sharedMPCController: MPCController {
        if let _ = _sharedMPCController {
            return _sharedMPCController!
        } else {
            _sharedMPCController = MPCController()
            println("%%% ### @@@ Creating a new controller")
            return _sharedMPCController!
        }
    }

    public var precedence: Int {
        return peerPrecedence(peerID)
    }

    public var isHighestPrecedence: Bool {
        return precedence == 0 ? true : false
    }

    public func peerPrecedence(aPeer: MCPeerID) -> Int {
        var precedence = 0
        for peer in peersWithStatus(.Connected) {
            if (UInt32(truncatingBitPattern: aPeer.hash) > UInt32(truncatingBitPattern: peer.hash)) {
                precedence++
            }
        }

        println("~~~~~ Peer: \(aPeer.displayName) Hash: \(UInt32(truncatingBitPattern: aPeer.hash)) Precedence: \(precedence)")
        return precedence
    }

    func isPeerHighestPrecedence(peer: MCPeerID) -> Bool {
        return peerPrecedence(peer) == 0 ? true : false
    }

    public class func destroySharedMPCController() {

        _sharedMPCController?.session.disconnect()
        _sharedMPCController?.peerController.removeAllPeers()
        _sharedMPCController?.peerController.delegate = nil
        _sharedMPCController?.session.delegate = nil
        _sharedMPCController?.advertiser.delegate = nil
        _sharedMPCController?.browser.delegate = nil
        _sharedMPCController = nil

        println("%%% ### @@@ Destroying shared mpc controller")
    }

    public var peerID: MCPeerID {
        return peerController.peerID
    }

    public var peers: Dictionary<MCPeerID, MPCPeerIDStatus> {
        return peerController.peers
    }

    public var peersSorted: [MCPeerID] {
        return peerController.peersSorted
    }

    public func peersWithStatus(status: MPCPeerIDStatus) -> [MCPeerID] {
        var desiredPeers = [MCPeerID]()

        for (aPeer, aStatus) in peerController.peers {
            if status == aStatus {
                desiredPeers.append(aPeer)
            }
        }

        return desiredPeers
    }

    override init() {

        operationMode = .SendAndReceive
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
        } else {
            println("MPCController is already Browsing")
        }
    }

    public func stopBrowsing() {
        if mode == .Browsing {
            mode = nil
            peerController.resetMode()
            browser.stopBrowsingForPeers()
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
        } else {
            println("MPCController is already Hosting")
        }
    }

    public func stopAdvertising() {
        if mode == .Advertising {
            mode = nil
            peerController.resetMode()
            advertiser.stopAdvertisingPeer()
        } else if mode != nil {
            println("MPCController can't stop hosting becuase it was not hosting")
        }
    }

    public func startJoining() {
        if mode != .Browsing {
            stopAdvertising()
            mode = .Browsing
            peerController.setJoiningMode()
            browser.startBrowsingForPeers()
        } else {
            println("MPCController is already Joining")
        }
    }

    public func stopJoining() {
        if mode != .Browsing {
            mode = nil
            peerController.resetMode()
            browser.stopBrowsingForPeers()
        } else if mode != nil {
            println("MPCController can't stop joining because it wsa not joining")
        }
    }

    public func getConnectedPeers() -> [MCPeerID] {
        return session.connectedPeers as [MCPeerID]
    }

    public func invitePeer(aPeer: MCPeerID) {

        peerController.peerWasInvited(aPeer)
        browser.invitePeer(aPeer,
            toSession: session,
            withContext: nil,
            timeout: kInviteTimeout)
    }

    public func sendMessage(msg: MPCMessage) {

        for peer in session.connectedPeers as [MCPeerID] {
            println("\(peerID.displayName) \t->\t \(peer.displayName) \t: \(msg.event)")
        }

        if !session.connectedPeers.isEmpty {
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

    public func queueMessage(message: MPCMessage) {
        messageQueue.append(message)
    }

    public func dequeueMessage() -> MPCMessage? {
        if messageQueue.isEmpty {
            return nil
        } else {
            return messageQueue.removeAtIndex(0)
        }
    }

    func processAllQueuedMessages() {
        var message = dequeueMessage()

        while message != nil {
            delegate?.didReceiveMessage(message!)
            message = dequeueMessage()
        }
    }

}

extension MPCController: MPCPeerControllerDelegate {

    func didUpdatePeers() {
        delegate?.didUpdatePeers()
    }

    func autoInvitePeer(peer: MCPeerID) {
        invitePeer(peer)
    }
}

extension MPCController: MCNearbyServiceBrowserDelegate {

    public func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        dispatch_async(timerQueue) {
            self.peerController.peerWasFound(peerID)
            println("MPC Controller - Peer was found \(peerID)")
        }
    }

    public func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        dispatch_async(timerQueue) {
            self.peerController.peerWasLost(peerID)
            println("MPC Controller - Peer was lost \(peerID)")
        }
    }

    public func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error.localizedDescription)
    }
}

extension MPCController: MCNearbyServiceAdvertiserDelegate {

    public func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {

        if session.connectedPeers.count < 3 {
            dispatch_async(timerQueue) {
                self.peerController.peerDidReceiveInvitation(peerID)
                invitationHandler(true, self.session)
                println("MPC Controller - Advertiser did receive invitation")
            }
        } else {
            println("MPC Controller - Rejecting invitation. Max player limit reached")
        }
    }

    public func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        println(error.localizedDescription)
    }
}

extension MPCController: MCSessionDelegate {

    public func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        dispatch_async(timerQueue) {
            switch state {
            case .Connecting:
                println("MPC Controller - Peer (\(peerID.description)) session did change state (connecting)")
                self.peerController.peerIsConnecting(peerID)
                self.delegate?.peerIsConnecting(peerID)

            case .Connected:
                println("MPC Controller - Peer (\(peerID.description)) session did change state (connected)")
                self.peerController.peerDidConnect(peerID)
                self.delegate?.peerDidConnect(peerID)

            case .NotConnected:
                println("MPC Controller - Peer (\(peerID.description)) session did change state (not connected)")
                self.peerController.peerDidNotConnect(peerID)
                self.delegate?.peerDidNotConnect(peerID)
            }
        }
    }

    public func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        if let msg = MPCMessage.deserialize(data){

            dispatch_async(timerQueue) {
                switch self.operationMode {
                case .SendAndReceive:
                    println("\(peerID.displayName) \t -> \t \(self.peerID.displayName) \t : \(msg.event)")
                    if let _ = self.delegate {
                        self.delegate?.didReceiveMessage(msg)
                    }
                case .SendAndQueueReceive:
                    println("\(peerID.displayName) \t -> \t Queue:\(self.peerID.displayName) \t: \(msg.event)")
                    self.queueMessage(msg)
                }
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