//
//  MPCMessageTests.swift
//  SnakeSwift
//
//  Created by PartyMan on 4/24/15.
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

    func testGetStartGameMessage() {

        let startTimeString: String = NSString(format: "%f", NSDate.timeIntervalSinceReferenceDate())
        let delayString = "3"

        let startMsg = MPCMessage.getStartGameMessage(startTimeString, delay: delayString)

        XCTAssertEqual(startMsg.event, MPCMessageEvent.StartGame, "Event = Start Game")
        XCTAssertEqual(startMsg.body[MPCMessageKey.GameStartTime]!, startTimeString, "Start time equal to the specified start time")
        XCTAssertEqual(startMsg.body[MPCMessageKey.GameDelay]!, delayString, "Delay equal to the specified delay")
    }

    func testSerialization() {

        let startTimeString: String = NSString(format: "%f", NSDate.timeIntervalSinceReferenceDate())
        let delayString = "3"
        let startMsg = MPCMessage.getStartGameMessage(startTimeString, delay: delayString)

        let msgData = startMsg.serialize()

        XCTAssert(msgData.length > 0, "Make sure it contains data")

        if let decodedMsg = MPCMessage.deserialize(msgData) {
            XCTAssertEqual(decodedMsg.event, MPCMessageEvent.StartGame, "Start game message event")
            XCTAssertEqual(decodedMsg.body[MPCMessageKey.GameStartTime]!, startTimeString, "Game start time")
            XCTAssertEqual(decodedMsg.body[MPCMessageKey.GameDelay]!, delayString, "Game delay")
        }
    }
}
