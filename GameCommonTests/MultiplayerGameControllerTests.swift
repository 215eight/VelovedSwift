//
//  MultiplayerGameControllerTests.swift
//  GameSwift
//
//  Created by eandrade21 on 5/25/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import MultipeerConnectivity

class MultiplayerGameControllerTests: XCTestCase {

    var controller: MultiplayerGameControllerMock!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        controller = MultiplayerGameControllerMock()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        controller = nil
        super.tearDown()
    }

    func testMultiplayerControllerCanProcessMessages() {

        var processedTestMessage = false
        controller.testMessageHandler = {(wasProcessed: Bool) in processedTestMessage = wasProcessed}
        controller.status = MultiplayerGameStatusForwardTest(controller: controller)

        let testMsg = MPCMessage.getTestMessage("Test")
        controller.processMessage(testMsg)

        XCTAssertTrue(processedTestMessage, "Message was processed")
    }

    func testMultiplayerControllerCanQueueMessages() {

        controller.status = MultiplayerGameStatusQueueTest(controller: controller)
        XCTAssertNil(controller.dequeueMessage(), "Queue should be empty")

        let testMsg = MPCMessage.getTestMessage("Test")
        controller.processMessage(testMsg)

        let queuedMsg = controller.dequeueMessage()

        XCTAssertNotNil(queuedMsg, "Queue should contatin test message")
        XCTAssertEqual(queuedMsg!.event, testMsg.event, "Events should match")
    }


    func testMultiplayerControllerIsInitializedWithIdleStatus() {

        let controller = MultiplayerGameController()
        var isIdleStatus = false

        if let _ = controller.status as? MultiplayerGameIdleStatus {
            isIdleStatus = true
        }

        XCTAssertTrue(isIdleStatus, "Controller initial status is idle")
    }

    func testMultiplayerControllerCanAssignTurn() {

        var controller0 = MultiplayerGameControllerMock()
        var peer0 = MCPeerID(displayName: "Peer 0")
        var controller1 = MultiplayerGameControllerMock()
        var peer1 = MCPeerID(displayName: "Peer 1")
        var controller2 = MultiplayerGameControllerMock()
        var peer2 = MCPeerID(displayName: "Peer 2")
        var controller3 = MultiplayerGameControllerMock()
        var peer3 = MCPeerID(displayName: "Peer 3")

        var allPeers: [MCPeerID] = [peer0, peer1, peer2, peer3]

        let turn0 = controller0.setTurn(peer0, allPeers: allPeers)
        let turn1 = controller1.setTurn(peer1, allPeers: allPeers)
        let turn2 = controller2.setTurn(peer2, allPeers: allPeers)
        let turn3 = controller3.setTurn(peer3, allPeers: allPeers)

        var turns = [turn0, turn1, turn2, turn3]
        sort(&turns){ $0 < $1 }

        XCTAssertEqual(turns[0], 0, "First turn is 0")
        XCTAssertEqual(turns[1], 1, "One unit is added to denote subsequent turns")
        XCTAssertEqual(turns[2], 2, "Third turn")
        XCTAssertEqual(turns[3], 3, "Total of turns = connected peers minus 1")

    }

    func testMultiplayerControllerCanAssignTurnWithOnlyOneConnectedPlayer() {

    }
}
