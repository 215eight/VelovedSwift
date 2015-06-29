//
//  MultiplayerGameStatusTests.swift
//  VelovedGame
//
//  Created by eandrade21 on 6/19/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import MultipeerConnectivity

class MultiplayerGameStatusTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMultiplayerGamePlayingStatusCanProcessPeerDidNotConnectMessage() {
        let multiplayerController = MultiplayerGameController()
        let gamePlayingStatus = MultiplayerGamePlayingStatus(controller: multiplayerController)
        multiplayerController.status = gamePlayingStatus

        let aPeer = MCPeerID(displayName: "aPeer")
        let peerDidNotConnectMessage = MPCMessage.getPeerDidNotConnectMessage(aPeer)
        multiplayerController.processMessage(peerDidNotConnectMessage)
        XCTAssertTrue(true, "")
    }


}
