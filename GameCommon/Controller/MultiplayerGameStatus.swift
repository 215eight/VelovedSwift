//
//  MultiplayerGameStatus.swift
//  GameSwift
//
//  Created by enadrade21 on 5/25/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class MultiplayerGameStatus: NSObject {

    weak var controller: MultiplayerGameController?

    init(controller: MultiplayerGameController) {
        self.controller = controller
        super.init()
    }

    func processMessage(message: MPCMessage) {
        let messageHandler = MPCMessage.getMessageHandler(message)
        messageHandler(self)
    }

    func forwardMessageToController(message: MPCMessage) {
        if let _ = controller {
            let messageHandler = MPCMessage.getMessageHandler(message)
            messageHandler(controller!)
        }
    }

    func queueMessageForProcessingLater(message: MPCMessage) {
        controller?.queueMessage(message)
    }

    func discardMessage(message: MPCMessage) {

        var errorMsg = String(format: "%@ - %@: Discarded the following message %@", [self.dynamicType.description(), __FUNCTION__, message.description])

        assertionFailure(errorMsg)
    }
}

extension MultiplayerGameStatus: GameMessages {

    func testMessage(message: MPCMessage) {
        assertionFailure("")
    }

    func initPlayerMessage(message: MPCMessage) {
        assertionFailure("")
    }

}

class MultiplayerGameModelInitStatus: MultiplayerGameStatus, GameMessages {
    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func initPlayerMessage(message: MPCMessage) {
        forwardMessageToController(message)
    }
}

class MultiplayerGameViewInitStatus: MultiplayerGameStatus, GameMessages {
    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func initPlayerMessage(message: MPCMessage) {
        discardMessage(message)
    }
}