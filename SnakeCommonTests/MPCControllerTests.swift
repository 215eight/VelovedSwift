//
//  MPCControllerTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import MultipeerConnectivity

class MPCControllerTests: XCTestCase {

    var controller: MPCController!

    override func setUp() {
        super.setUp()
        controller = MPCController()
    }
    
    override func tearDown() {
        controller = nil
        super.tearDown()
    }

    #if os(iOS)
    func testControllerReusesPeerID() {

        let originalPeerID  = controller.peerID
        controller = nil

        controller = MPCController()
        let newPeerID = controller.peerID

        XCTAssertEqual(originalPeerID, newPeerID, "PeerIDs must be reused")
    }
    #endif

    func testControllerAddsItselfToThePeerCollection() {
        XCTAssertTrue(controller.peers.count == 1, "It should contain itself")
        XCTAssertEqual(controller.peers[controller.peerID]!, MPCPeerIDStatus.Initialized, "Status is initialized")
    }

    func testFoundPeerIsSaved() {

        let foundPeer = MCPeerID(displayName: "aPeer")
        controller.browser(controller.browser, foundPeer: foundPeer, withDiscoveryInfo: nil)

        XCTAssertTrue(controller.peers.count == 2, "Itself and new found peer")
        XCTAssertEqual(controller.peers[foundPeer]!, MPCPeerIDStatus.Found, "Status of new found peer is found")
    }

    func testLostPeerIsRemoved() {

        let lostPeer = MCPeerID(displayName: "aPeer")
        controller.peers[lostPeer] = MPCPeerIDStatus.Found

        controller.browser(controller.browser, lostPeer: lostPeer)

        XCTAssertTrue(controller.peers.count == 1, "Lost peer was lost hence itself should be the only peer in the collection")
        XCTAssertEqual(controller.peers.keys.first!, controller.peerID, "Existing peer is itself")
    }

    func testBrowserDidInvitePeer() {

        let invitedPeer = MCPeerID(displayName: "aPeer")
        controller.peers[invitedPeer] = MPCPeerIDStatus.Found

        controller.inivitePeer(invitedPeer)

        XCTAssertTrue(controller.peers.count == 2, "Itself and invited peer")
        XCTAssertEqual(controller.peers[invitedPeer]!, MPCPeerIDStatus.Validating, "Invited peer is invited")
    }

    func testAdvertiserDidReceiveInvitation() {
        let inviterPeer = MCPeerID(displayName: "Inviter")

        var handler = { (action: Bool, session: MCSession!) -> Void in
        }

        controller.advertiser(controller.advertiser, didReceiveInvitationFromPeer: inviterPeer, withContext: nil, invitationHandler: handler)
        XCTAssertTrue(controller.peers.count == 2, "Itself and the inviting peer")
        XCTAssertEqual(controller.peers[inviterPeer]!, MPCPeerIDStatus.Joining, "Inviter is joining the game")
    }

    func testPeersAreConnecting() {
        let connectingPeer = MCPeerID(displayName: "Connecting Peer")
        controller.peers[connectingPeer] = MPCPeerIDStatus.Joining

        controller.session(controller.session, peer: connectingPeer, didChangeState: MCSessionState.Connecting)

        XCTAssertTrue(controller.peers.count == 2, "Itself and the connecting peer")
        XCTAssertEqual(controller.peers[controller.peerID]!, MPCPeerIDStatus.Connecting, "Itself should be connecting")
        XCTAssertEqual(controller.peers[connectingPeer]!, MPCPeerIDStatus.Connecting, "Connecting peer should be connecting")
    }

    func testPeersDidConnect() {
        let connectedPeer = MCPeerID(displayName: "Connected Peer")
        controller.peers[connectedPeer] = MPCPeerIDStatus.Connecting

        controller.session(controller.session, peer: connectedPeer, didChangeState: MCSessionState.Connected)

        XCTAssertTrue(controller.peers.count == 2, "Itself and connected peer")
        XCTAssertEqual(controller.peers[controller.peerID]!, MPCPeerIDStatus.Connected, "Itself should be connected")
        XCTAssertEqual(controller.peers[connectedPeer]!, MPCPeerIDStatus.Connected, "Connected peer should be connected")
    }

    func testPeerDidNotConnect() {
        let disconnectedPeer = MCPeerID(displayName: "Disconnected Peer")
        controller.peers[disconnectedPeer] = MPCPeerIDStatus.Connected

        controller.session(controller.session, peer: disconnectedPeer, didChangeState: MCSessionState.NotConnected)

        XCTAssertTrue(controller.peers.count == 1, "Itself only")
        XCTAssertEqual(controller.peers[controller.peerID]!, MPCPeerIDStatus.Hosting, "Its status back to hosting")
    }
}