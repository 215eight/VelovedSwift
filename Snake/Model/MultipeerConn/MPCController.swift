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

enum MPCControllerMode {
    case Browsing
    case Advertising
}

class MPCController: NSObject {

    private var peerID: MCPeerID
    var session: MCSession
    private var browser: MCNearbyServiceBrowser?
    private var advertiser: MCNearbyServiceAdvertiser?

    var invitationHandler: ((Bool, MCSession!) -> Void)!
    dynamic var foundPeers = [MCPeerID]()
    dynamic var peerInvites = [PeerInvite]()

    init(mode: MPCControllerMode) {
        #if os(iOS)
            peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        #elseif os(OSX)
            peerID = MCPeerID(displayName: NSHost.currentHost().name)
        #endif
        
        session = MCSession(peer: peerID)

        super.init()

        session.delegate = self

        switch mode{
        case .Browsing:
            browser = MCNearbyServiceBrowser(peer: peerID, serviceType: kServiceID)
            browser?.delegate = self
        case .Advertising:
            advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: kServiceID)
            advertiser?.delegate = self
        }

    }


    func startBrowsing() {
        assert(browser != nil, "MPCController not initialized on browsing mode")
        browser?.startBrowsingForPeers()
    }

    func stopBrowsing() {
        assert(browser !=  nil, "MPCController not initialized on browsing mode")
        browser?.stopBrowsingForPeers()
    }

    func startAdvertising() {
        assert(advertiser != nil, "MPCController not initialized on advertising mode")
        advertiser?.startAdvertisingPeer()
    }

    func stopAdvertising() {
        assert(advertiser != nil, "MCPController not initialized on advertising mode")
        advertiser?.stopAdvertisingPeer()
    }

    func peerWithName(displayName: String?) -> MCPeerID? {
        if let peerDisplayName = displayName {
            for aPeer in foundPeers {
                if peerDisplayName == aPeer.displayName {
                    return aPeer
                }
            }
        }

        return nil
    }

    func invitePeer(aPeer: MCPeerID) {
        assert(browser != nil, "MPCController not initialized on browsing mode")
        browser?.invitePeer(aPeer,
            toSession: session,
            withContext: nil,
            timeout: kInviteTimeout)
    }
}

extension MPCController: MCNearbyServiceBrowserDelegate {

    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        println("Browser \(browser) found a peer \(peerID.displayName)")
        foundPeers.append(peerID)
    }

    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        for (index, aPeer) in enumerate(foundPeers) {
            if peerID == aPeer {
                foundPeers.removeAtIndex(index)
                break
            }
        }
    }

    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error.localizedDescription)
    }
}

extension MPCController: MCNearbyServiceAdvertiserDelegate {

    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        let peerInvite = PeerInvite(peerID: peerID, status: PeerInviteStatus.Pending, inviteHandler: invitationHandler)
        processInvite(peerInvite)
    }

    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        println(error.localizedDescription)
    }

    func processInvite(peerInvite: PeerInvite) {
        for (index, aPeerInvite) in enumerate(peerInvites) {
            if peerInvite.peerID.displayName == aPeerInvite.peerID.displayName {
                peerInvites[index] = peerInvite
                return
            }
        }

        peerInvites.append(peerInvite)
    }
}

extension MPCController: MCSessionDelegate {
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        switch state {
        case .Connecting:
            println("Session connecting")
        case .Connected:
            println("Session connected with peer \(peerID.displayName)")
            for (index, aPeerInvite) in enumerate(peerInvites) {
                if aPeerInvite.peerID === peerID {
                    aPeerInvite.status = PeerInviteStatus.Accepted
                    peerInvites[index] = aPeerInvite
                }
            }
        case .NotConnected:
            println("Session not connected")
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