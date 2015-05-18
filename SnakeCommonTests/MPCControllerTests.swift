//
//  MPCControllerTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class MPCControllerTests: XCTestCase {

    var controller: MPCController!

    weak var foundExpectation: XCTestExpectation?

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

    func testFoundPeerWillCallDelegate() {
        foundExpectation = self.expectationWithDescription("Found Peer Expectation")

        controller.delegate = self

        controller.browser(controller.browser, foundPeer: newPlayer.peerID, withDiscoveryInfo: ["uID":newPlayer.uniqueID.UUIDString])

        self.waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testLostPeerWillCallDelegate() {
//        foundExpectation = self.expectationWithDescription("Lost Peer should be called")

//        controller.delegate = self


//        controller.browser(controller.browser, lostPeer: newPlayer.peerID)
    }
}

extension MPCControllerTests: MPCControllerDelegate {

    func didReceiveMessage(msg: MPCMessage) {
        foundExpectation?.fulfill()
    }
}
