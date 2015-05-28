//
//  MultiplayerGameControllerMock.swift
//  GameSwift
//
//  Created by eandrade21 on 5/25/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

class MultiplayerGameControllerMock: MultiplayerGameController, GameMessages {

    var testMessageHandler: ((Bool) -> Void)?

    override init() {
        super.init()
        status = MultiplayerGameIdleStatus(controller: self)
    }

    override func testMessage(message: MPCMessage) {
        testMessageHandler?(true)
    }
}

class MultiplayerGameStatusForwardTest: MultiplayerGameStatus {
    override func testMessage(message: MPCMessage) {
        forwardMessageToController(message)
    }
}

class MultiplayerGameStatusQueueTest: MultiplayerGameStatus {
    override func testMessage(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }
}