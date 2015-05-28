//
//  MPCMessageTests.swift
//  GameSwift
//
//  Created by eandrade21 on 4/24/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class MPCMessageTests: XCTestCase {

    func testScheduleGameMessage() {

        let gameStartDate = NSDate(timeIntervalSince1970: 3)
        let gameStartString: String = String(format: "%f", gameStartDate.timeIntervalSince1970)

        let scheduleMsg = MPCMessage.getScheduleGameMessage(gameStartString)

        XCTAssertEqual(scheduleMsg.event, MPCMessageEvent.ScheduleGame, "Event = Schedule Game")

        let startDate = scheduleMsg.body![MPCMessageKey.GameStartDate.rawValue]! as String
        XCTAssertEqual(startDate, gameStartString , "Game Strat Date equal to the specified start date")
    }

    func testSetUpMessage() {
        let setUpMsg = MPCMessage.getSetUpGameMessage()

        XCTAssertEqual(setUpMsg.event, MPCMessageEvent.SetUpGame, "Event = Test Message")
        XCTAssert(setUpMsg.body == nil, "Body should be nil")

        let setUpMsgData = setUpMsg.serialize()
        XCTAssert(setUpMsgData.length > 0, "It contains something")

        if let decodedMsg = MPCMessage.deserialize(setUpMsgData) {
            XCTAssertEqual(decodedMsg.event, MPCMessageEvent.SetUpGame, "Event = Test Message")
            XCTAssert(decodedMsg.body == nil, "Body should be nil")
        }
    }

    func testSerialization() {

        let testMsgBody = "Hello World!"
        let testMsg = MPCMessage.getTestMessage(testMsgBody)

        let msgData = testMsg.serialize()

        XCTAssert(msgData.length > 0, "Make sure it contains data")

        if let decodedMsg = MPCMessage.deserialize(msgData) {
            XCTAssertEqual(decodedMsg.event, MPCMessageEvent.TestMsg, "Test message event")

            let testDecodedMsgBody = decodedMsg.body![MPCMessageKey.TestMsgBody.rawValue]! as String
            XCTAssertEqual(testDecodedMsgBody, testMsgBody, "Msg Body")
        }
    }

}
