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
}
