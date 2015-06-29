//
//  MPCPeerControllerTests.swift
//  VelovedGame
//
//  Created by eandrade21 on 5/19/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import MultipeerConnectivity

extension MPCPeerControllerTest: MPCPeerControllerDelegate {
    func didUpdatePeers() {
        
    }

    func autoInvitePeer(peer: MCPeerID) {
        autoInviteExpectation?.fulfill()
    }
}

class MPCPeerControllerTest: XCTestCase {

    var peerController: MPCPeerController!
    weak var autoInviteExpectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        peerController = MPCPeerController()
        peerController.delegate = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        peerController.delegate = nil
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

    func testControllerAddsItselfToThePeerCollectionWhenInitialized() {
        XCTAssertTrue(peerController.peers.count == 1, "It should only contain itself")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Initialized, "Status is initialized")
    }

    func testControllerUpdatesTheInstancePeerIDWhenBrowsingWithoutConnectedPeers() {
        peerController.setBrowsingMode()
        XCTAssertTrue(peerController.peers.count == 1, "It should only contain itself")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Browsing, "Status should be browsing")
    }

    func testControllerUpdatesTheInstancePeerIDWithAdvertisingWithoutConnectedPeers() {
        peerController.setAdvertisingMode()
        XCTAssertTrue(peerController.peers.count == 1, "It should only contain itself")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Hosting, "Status should be hosting")
    }

    func testControllerDoesNotRemoveConnectedPeerWhenResetingMode() {
        peerController.setAdvertisingMode()
        let aPeer = MCPeerID(displayName: "Connected")
        peerController.peerDidReceiveInvitation(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidConnect(aPeer)
        peerController.resetMode()

        XCTAssertTrue(peerController.peers.count == 2, "Itself and connected peer")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Connected, "Connected")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Connected, "Connected")
    }

    func testControllerDoesNotUpdateInstancePeerIDWhenBrowsingWithAlreadyConnectedPeers() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Connected")
        peerController.peerWasFound(aPeer)
        peerController.peerWasInvited(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidConnect(aPeer)
        peerController.resetMode()
        peerController.setBrowsingMode()

        XCTAssertTrue(peerController.peers.count == 2, "Itself and connected peer")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Connected, "Connected")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Connected, "Connected")
    }

    func testControllerDoesNotUpdateInstancePeerIDWhenAdvertisingWithAlreadyConnectedPeers() {
        peerController.setAdvertisingMode()
        let aPeer = MCPeerID(displayName: "Connected")
        peerController.peerDidReceiveInvitation(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidConnect(aPeer)
        peerController.resetMode()
        peerController.setAdvertisingMode()

        XCTAssertTrue(peerController.peers.count == 2, "Itself and connected peer")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Connected, "Connected")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Connected, "Connected")
    }

    func testControllerAddsFoundPeerOnBrowsingMode() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Found")
        peerController.peerWasFound(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and new found peer")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Found, "Status found")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Browsing, "Still on browsing status")
    }

    func testControllerDoesNotAddFoundPeerOnBrowsingModeWhenPeerAlreadyExist() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Connected")
        peerController.peerWasFound(aPeer)
        peerController.peerWasInvited(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidConnect(aPeer)
        peerController.peerWasFound(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and connected peer")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Connected, "Status should remain as connected")
    }

    func testControllerDoesNotAddFoundPeerOnAdvertisingMode() {
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

    func testControllerRemovesLostPeerOnlyIfPeerIsOnFoundStatusOnBrowsingMode() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Connecting")
        peerController.peerWasFound(aPeer)
        peerController.peerWasInvited(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerWasLost(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and connecting peer")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Connecting, "Connecting")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Connecting, "Connecting")

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


    func testControllerReceivesDisconnectMessageOnIdleMode() {
        peerController.setBrowsingMode()
        let aPeer = MCPeerID(displayName: "Disconnected")
        peerController.peerWasFound(aPeer)
        peerController.peerWasInvited(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidConnect(aPeer)
        peerController.resetMode()
        peerController.peerDidNotConnect(aPeer)

        XCTAssertTrue(peerController.peers.count == 1, "Itself only. Disconnected peer is gone")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Initialized, "Initialized")
    }

    func testUpdateStatusKeepSortedPeers() {

        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Initialized, "Only itself")
        XCTAssertEqual(peerController.peersSorted.first!, peerController.peerID, "Only itself should exist")

        let aNewPeer = MCPeerID(displayName: "aNewPeer")
        peerController.updateStatus(.Initialized, forPeer: aNewPeer)

        XCTAssertEqual(peerController.peersSorted[0], peerController.peerID, "Itself")
        XCTAssertEqual(peerController.peersSorted[1], aNewPeer, "aNewPeer")

        peerController.updateStatus(.Connecting, forPeer: aNewPeer)
        XCTAssertEqual(peerController.peersSorted[0], peerController.peerID, "Itself")
        XCTAssertEqual(peerController.peersSorted[1], aNewPeer, "aNewPeer")
        XCTAssertTrue(peerController.peersSorted.count == 2, "Updating an existing peer should not add a new sorted peer")

        let aSecondNewPeer = MCPeerID(displayName: "aSecondNewPeer")
        peerController.updateStatus(.Initialized, forPeer: aSecondNewPeer)

        XCTAssertEqual(peerController.peersSorted[0], peerController.peerID, "Itself")
        XCTAssertEqual(peerController.peersSorted[1], aNewPeer, "aNewPeer")
        XCTAssertEqual(peerController.peersSorted[2], aSecondNewPeer, "aSecondNewPeer")
    }

    func testControllerFindsPeersOnJoiningMode() {
        peerController.setJoiningMode()
        let aPeer = MCPeerID(displayName: "Found")
        peerController.peerWasFound(aPeer)

        XCTAssertTrue(peerController.peers.count == 2, "Itself and new found peer")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Found, "Status found")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Browsing, "Still on browsing status")
    }

    func testControllerDoesNotAddAnotherFoundPeerIfAlreadyFoundOneOnJoiningMode() {
        peerController.setJoiningMode()
        let aPeer = MCPeerID(displayName: "Found")
        peerController.peerWasFound(aPeer)

        let aNewPeer = MCPeerID(displayName: "Newly Found")
        peerController.peerWasFound(aNewPeer)


        XCTAssertTrue(peerController.peers.count == 2, "Itself and new found peer")
        XCTAssertEqual(peerController.peers[aPeer]!, MPCPeerIDStatus.Found, "Status found")
        XCTAssertEqual(peerController.peers[peerController.peerID]!, MPCPeerIDStatus.Browsing, "Still on browsing status")
    }

    func testControllerAutoInvitePeerAfterBeingFoundOnJoiningMode() {

        autoInviteExpectation = self.expectationWithDescription("Auto Invite Expectation")

        peerController.setJoiningMode()
        let aPeer = MCPeerID(displayName: "Found")
        peerController.peerWasFound(aPeer)

        self.waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testControllerDisconnectPeersOnJoiningMode() {
        peerController.setJoiningMode()
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

    func testCornerCase() {
        peerController.setJoiningMode()
        let aPeer = MCPeerID(displayName: "Not Connected")
        peerController.peerWasFound(aPeer)
        peerController.peerWasInvited(aPeer)
        peerController.peerIsConnecting(aPeer)
        peerController.peerDidConnect(aPeer)
        peerController.peerDidNotConnect(aPeer)


    }


}
