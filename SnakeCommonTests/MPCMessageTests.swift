//
//  MPCMessageTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/24/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa
import XCTest

class MPCMessageTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetUpSnakesMessage() {

        let snakeLocations = [StageLocation(x: 0, y: 0),
        StageLocation(x: 0, y: 1)]

        let snakeDirection = Direction.randomDirection()

        let snake1 = Snake(locations: snakeLocations, direction: snakeDirection)
        let snake2 = Snake(locations: snakeLocations, direction: snakeDirection)

        let snakeMap = [ "peerID1" : snake1,
            "peerID2" : snake2]

        let setUpSnakeMsg = MPCMessage.getSetUpSnakesMessage(snakeMap)

        XCTAssertEqual(setUpSnakeMsg.event, MPCMessageEvent.SetUpSnakes, "Event = Set Up Snakes")

        let msgSnake1 = setUpSnakeMsg.body!["peerID1"]! as Snake
        let msgSnake2 = setUpSnakeMsg.body!["peerID2"]! as Snake

        XCTAssertEqual(msgSnake1, snake1, "")
        XCTAssertEqual(msgSnake2, snake2, "")

        let msgData = setUpSnakeMsg.serialize()
        let decodedMsg = MPCMessage.deserialize(msgData)

        XCTAssertEqual(decodedMsg!.event, MPCMessageEvent.SetUpSnakes, "Event = Set Up Snakes")

        let decodedSnake1 = decodedMsg!.body!["peerID1"]! as Snake
        let decodedSnake2 = decodedMsg!.body!["peerID2"]! as Snake

        XCTAssertEqual(decodedSnake1, snake1, "")
        XCTAssertEqual(decodedSnake2, snake2, "")

    }

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
