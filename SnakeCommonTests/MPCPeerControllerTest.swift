//
//  MPCPeerControllerTest.swift
//  SnakeSwift
//
//  Created by PartyMan on 5/19/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import MultipeerConnectivity

class MPCPeerControllerTest: XCTestCase {

    var peerController: MPCPeerController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        peerController = MPCPeerController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        peerController = nil
        super.tearDown()
    }

    #if os(iOS)
    func testControllerReusesPeerID() {

    let originalPeerID = peerController.peerID
    peerController = nil

    peerController = MPCPeerController()
    let newPeerID = peerController.peerID

    XCTAssertEqual(originalPeerID, newPeerID, "PeerIDs must be reused")
    }
    #endif

    func testControllerAddsItselfToThePeerCollection() {
        XCTAssertTrue(peerController.peers.count == 1, "It should only contain itself")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Initialized, "Status is initialized")
    }

    func testControllerUpdatesTheInstancePeerIDWhenBrowsing() {
        peerController.setBrowsingMode()
        XCTAssertTrue(peerController.peers.count == 1, "It should only contain itself")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Browsing, "Status should be browsing")
    }

    func testControllerUpdateTheInstancePeerIDWithAdvertising() {
        peerController.setAdvertisingMode()
        XCTAssertTrue(peerController.peers.count == 1, "It should only contain itself")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Hosting, "Status should be hosting")
    }

    func testControllerAddsFoundPeersOnBrowsingMode() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Found")
        peerController.peerWasFound(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and new found peer")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Found, "Status found")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Browsing, "Still on browsing status")
    }

    func testControllerDoesNotAddFoundPeersOnAdvertisingMode() {
        peerController.setAdvertisingMode()
        let aPeer = MCPeerID(displayName: "Found")
        peerController.peerWasFound(aPeer)

        XCTAssertTrue(peerController.peers.count == 1, "Itself only, new found should not be added")
    }

    func testControllerRemovesLostPeerOnBrowsingMode() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Lost")
        peerController.peerWasFound(aPeer)

        peerController.peerWasLost(aPeer)

        XCTAssertTrue(peerController.peers.count == 1, "Itself only. Lost peer is removed" )
    }

    func testControllerDoesNotRemoveLostPeerOnAdvertisingMode() {
        peerController.setAdvertisingMode()
        let aPeer = MCPeerID(displayName: "Lost")
        peerController.peerWasLost(aPeer)

        XCTAssertTrue(peerController.peers.count == 1, "Itself only. This operation doesn't do anything")
    }

    func testControllerInvitesPeerOnBrowsingMode() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Invited")
        peerController.peerWasFound(aPeer)
        peerController.peerWasInvited(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and the invited peer")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Accepting, "Invited peer is accepting the request")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Joining, "Itself is joining a game")
    }

    func testControllerDoesNotInvitePeerOnAdvertisingMode() {
        peerController.setAdvertisingMode()
        let aPeer = MCPeerID(displayName: "Invited")
        peerController.peerWasInvited(aPeer)

        XCTAssertTrue(peerController.peers.count == 1, "Itself only. This operation doesn't do anything")
    }

    func testControllerDoesReceiveInvitationOnAdvertisingMode() {
        peerController.setAdvertisingMode()
        let aPeer = MCPeerID(displayName: "Inviter")
        peerController.peerDidReceiveInvitation(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and the inviter")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Joining, "Inviter is joining")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Accepting, "Itself is accepting the request")
    }

    func testControllerDoesNotReceiveInvitatiosnOnBrowsingMode() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Inviter")
        peerController.peerDidReceiveInvitation(aPeer)

        XCTAssertTrue(peerController.peers.count == 1, "Itself only. This operation doesn't do anything")
    }

    func testControllerIsConnectingPeersOnBrowsingMode() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Connecting")
        peerController.peerWasFound(aPeer)
        peerController.peerWasInvited(aPeer)
        peerController.peerIsConnecting(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and the connecting peer")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Connecting, "Connecting")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Connecting, "Connecting")
    }

    func testControllerIsConnectingPeersOnAdvertisingMode() {
        peerController.setAdvertisingMode()
        let aPeer = MCPeerID(displayName: "Connecting")
        peerController.peerDidReceiveInvitation(aPeer)
        peerController.peerIsConnecting(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and the connecting peer")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Connecting, "Connecting")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Connecting, "Connecting")
    }

    func testControllerDidConnectPeersOnBorwsingMode() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Connected")
        peerController.peerWasFound(aPeer)
        peerController.peerWasInvited(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidConnect(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and the connected peer")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Connected, "Connected")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Connected, "Connected")
    }

    func testControllerDidConnectPeersOnAdvertisingMode() {
        peerController.setAdvertisingMode()
        let aPeer = MCPeerID(displayName: "Connected")
        peerController.peerDidReceiveInvitation(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidConnect(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and the connected peer")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Connected, "Connected")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Connected, "Connected")
    }

    func testControllerDisconnectPeersOnBrowsingMode() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Not Connected")
        peerController.peerWasFound(aPeer)
        peerController.peerWasInvited(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidConnect(aPeer)
        peerController.peerDidNotConnect(aPeer)

        XCTAssertTrue(peerController.peers.count == 1, "Itself only. Disconnected peer is gone")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Browsing, "Browsing")

        peerController.peerWasFound(aPeer)
        peerController.peerWasInvited(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidNotConnect(aPeer)

        XCTAssertTrue(peerController.peers.count == 1, "Itself only, Disconnected peer is gone")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Browsing, "Browsing")
    }

    func testControllerDisconnectPeersOnAdvertisingMode() {
        peerController.setAdvertisingMode()
        let aPeer = MCPeerID(displayName: "Not Connected")
        peerController.peerDidReceiveInvitation(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidConnect(aPeer)
        peerController.peerDidNotConnect(aPeer)

        XCTAssertTrue(peerController.peers.count == 1, "Itself only. Disconnected peer is gone")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Hosting, "Hosting")

        peerController.peerDidReceiveInvitation(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidNotConnect(aPeer)

        XCTAssertTrue(peerController.peers.count == 1, "Itself only. Disconnected peer is gone")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Hosting, "Hosting")
    }
}
