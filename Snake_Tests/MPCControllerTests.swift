//
//  MPCControllerTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import MultipeerConnectivity

class MPCContollerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddFoundPeer() {
        let mpc = MPCController()

        XCTAssertEqual(mpc.foundPeers.count, 0, "There should be no found peers")

        let aPeer = MCPeerID(displayName: "MacBookPro")
        mpc.addFoundPeer(aPeer)

        XCTAssertEqual(mpc.foundPeers.count, 1, "MacBookPro is now a found peer")
        XCTAssert(mpc.foundPeers[0] === aPeer, "Check is the reference points to the same object")

        let aPeer2 = MCPeerID(displayName: "MacBookPro")
        mpc.addFoundPeer(aPeer2)
        XCTAssertEqual(mpc.foundPeers.count, 1, "Last added peer had the same name of an already added peer. Count should remain the same")
        XCTAssert(mpc.foundPeers[0] === aPeer, "Check the reference is still to the same object")
    }

    func testInvitePeerWithName() {
        let mpc = MPCController()
        let aPeer = MCPeerID(displayName: "MacBookPro")
        mpc.addFoundPeer(aPeer)

        XCTAssertEqual(mpc.peerInvites.count, 0, "There should be no peer invites yet")

        mpc.setMode(MPCControllerMode.Browsing)
        mpc.invitePeerWithName("MacBookPro")

        XCTAssertEqual(mpc.peerInvites.count, 2, "An invite for the found peer and itself should be stored")

    }

    func testUpdatePeerInvite() {
        let mpc = MPCController()
        let aPeer = MCPeerID(displayName: "MacBookPro")
        mpc.addFoundPeer(aPeer)
        mpc.setMode(MPCControllerMode.Browsing)
        mpc.invitePeerWithName("MacBookPro")

        mpc.updatePeerInvite(aPeer, withStatus: PeerInviteStatus.Connecting)

        let peerInvite = mpc.peerInvites[1]
        XCTAssertEqual(peerInvite.status, PeerInviteStatus.Connecting, "Status should be updated from Pending to Connecting status")
    }

    func tesMultipleInvites() {
        let mpc = MPCController()
        let aPeer = MCPeerID(displayName: "MacBookPro")
        mpc.addFoundPeer(aPeer)
        mpc.setMode(MPCControllerMode.Browsing)
        mpc.invitePeerWithName("MacBookPro")

        mpc.updatePeerInvite(aPeer, withStatus: PeerInviteStatus.Connecting)

        let aPeer2 = MCPeerID(displayName: "MacBookPro")
        mpc.addFoundPeer(aPeer2)
        mpc.invitePeerWithName("MacBookPro")
        mpc.updatePeerInvite(aPeer2, withStatus: PeerInviteStatus.Connecting)
    }
}