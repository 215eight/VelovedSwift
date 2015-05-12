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

    func testSnakeDidChangeDirectionMessage() {
        let direction = Direction.Up

        let snakeDidChangeDirectionMsg = MPCMessage.getSnakeDidChangeDirectionMessage(direction)

        XCTAssertEqual(snakeDidChangeDirectionMsg.event, MPCMessageEvent.SnakeDidChangeDirection, "")
        let directionDesc = snakeDidChangeDirectionMsg.body![MPCMessageKey.SnakeDirection.rawValue]! as String
        XCTAssertEqual(directionDesc, direction.rawValue.description, "")
    }

    func testSetUpSnakesMessage() {

        let snakeLocations = [StageLocation(x: 0, y: 0),
        StageLocation(x: 0, y: 1)]

        let snakeDirection = Direction.randomDirection()

        let snakeConfig1 = SnakeConfiguration(locations: snakeLocations, direction: snakeDirection, type: .Solid)
        let snakeConfig2 = SnakeConfiguration(locations: snakeLocations, direction: snakeDirection, type: .Solid)

        let snakeConfigMap = [ "peerID1" : snakeConfig1,
            "peerID2" : snakeConfig2]

        let setUpSnakeMsg = MPCMessage.getSetUpSnakesMessage(snakeConfigMap)

        XCTAssertEqual(setUpSnakeMsg.event, MPCMessageEvent.SetUpSnakes, "Event = Set Up Snakes")

        let msgSnake1 = setUpSnakeMsg.body!["peerID1"]! as SnakeConfiguration
        let msgSnake2 = setUpSnakeMsg.body!["peerID2"]! as SnakeConfiguration

        XCTAssertEqual(msgSnake1.locations, snakeConfig1.locations, "")
        XCTAssertEqual(msgSnake1.direction, snakeConfig1.direction, "")
        XCTAssertEqual(msgSnake1.type, snakeConfig1.type, "")
        XCTAssertEqual(msgSnake2.locations, snakeConfig2.locations, "")
        XCTAssertEqual(msgSnake2.direction, snakeConfig2.direction, "")
        XCTAssertEqual(msgSnake2.type, snakeConfig2.type, "")

        let msgData = setUpSnakeMsg.serialize()
        let decodedMsg = MPCMessage.deserialize(msgData)

        XCTAssertEqual(decodedMsg!.event, MPCMessageEvent.SetUpSnakes, "Event = Set Up Snakes")

        let decodedSnake1 = decodedMsg!.body!["peerID1"]! as SnakeConfiguration
        let decodedSnake2 = decodedMsg!.body!["peerID2"]! as SnakeConfiguration

        XCTAssertEqual(decodedSnake1.locations, snakeConfig1.locations, "")
        XCTAssertEqual(decodedSnake1.direction, snakeConfig1.direction, "")
        XCTAssertEqual(decodedSnake1.type, snakeConfig1.type, "")
        XCTAssertEqual(decodedSnake2.locations, snakeConfig2.locations, "")
        XCTAssertEqual(decodedSnake2.direction, snakeConfig2.direction, "")
        XCTAssertEqual(decodedSnake2.type, snakeConfig2.type, "")

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
