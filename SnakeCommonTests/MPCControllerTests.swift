//
//  MPCControllerTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa
import XCTest

class MPCControllerTests: XCTestCase {

    var controller: MPCController!

    weak var foundExpectation: XCTestExpectation?

    override func setUp() {
        super.setUp()

        let playerDelegate = MPCGamePlayerDelegateMock()
        let player = MPCGamePlayer(delegate: playerDelegate)

        controller = MPCController()
        controller.setPlayer(player)
    }
    
    override func tearDown() {
        controller = nil
        super.tearDown()
    }

    func testInitWithMock() {

        XCTAssertNotNil(controller.player, "")
        XCTAssertNotNil(controller.session, "")
        XCTAssertNotNil(controller.browser, "")
        XCTAssertNotNil(controller.advertiser, "")
        XCTAssertNotNil(controller.peerID, "")
    }

    func testFoundPeer() {

        foundExpectation = self.expectationWithDescription("Found Peer Expectation")

        controller.delegate = self

        let newPlayerDelegate = MPCGamePlayerDelegateMock()
        let newPlayer = MPCGamePlayer(delegate: newPlayerDelegate)
        controller.browser(controller.browser, foundPeer: newPlayer.peerID, withDiscoveryInfo: ["uID":newPlayer.uniqueID.UUIDString])

        self.waitForExpectationsWithTimeout(1, handler: nil)

    }
}

extension MPCControllerTests: MPCControllerDelegate {

    func didFindPlayer(player: MPCGamePlayer) {
        foundExpectation?.fulfill()
    }

    func didReceiveMessage(msg: MPCMessage) {
        foundExpectation?.fulfill()
    }
}
