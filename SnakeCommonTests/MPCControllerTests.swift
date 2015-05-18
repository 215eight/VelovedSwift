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
        XCTAssertEqual(controller.peers[invitedPeer]!, MPCPeerIDStatus.Invited, "Invited peer is invited")
    }

    func testAdvertiserDidReceiveInvitation() {

    }
}