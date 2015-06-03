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

        var message = controller.dequeueMessage()
        while message != nil {
            processMessage(message!)
            message = controller.dequeueMessage()
        }
    }

    func processMessage(message: MPCMessage) {
        let messageHandler = MPCMessage.getMessageHandler(message)
        messageHandler(self)
    }

    func forwardMessageToController(message: MPCMessage) {
        if let _ = controller {
            println("\(self) forwarding \(message)\n")
            let messageHandler = MPCMessage.getMessageHandler(message)
            messageHandler(controller!)
        }
    }

    func queueMessageForProcessingLater(message: MPCMessage) {
        println("\(self) queueing message \(message)")
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

    func didShowGameViewController(message: MPCMessage) {
        assertionFailure("")
    }

    func scheduleGame(message: MPCMessage) {
        assertionFailure("")
    }

    func didScheduleGame(message: MPCMessage) {
        assertionFailure("")
    }

    func elementDidMoveMessage(message: MPCMessage) {
        assertionFailure("")
    }

    func playerDidCrash(message: MPCMessage) {
        assertionFailure("")
    }

    func gameDidEnd(message: MPCMessage) {
        assertionFailure("")
    }
}


class MultiplayerGameIdleStatus: MultiplayerGameStatus, GameMessages {
    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func initPlayerMessage(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func scheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        discardMessage(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        discardMessage(message)
    }
}

class MultiplayerGameModelInitStatus: MultiplayerGameStatus, GameMessages {
    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func initPlayerMessage(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func scheduleGame(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        discardMessage(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        discardMessage(message)
    }
}

class MultiplayerGameViewInitStatus: MultiplayerGameStatus, GameMessages {

    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        discardMessage(message)
    }

    override func initPlayerMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func scheduleGame(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        discardMessage(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        discardMessage(message)
    }
}

class MultiplayerGameWaitingToScheduleGameStatus: MultiplayerGameStatus, GameMessages {

    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        discardMessage(message)
    }

    override func initPlayerMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func scheduleGame(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        discardMessage(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        discardMessage(message)
    }
}

class MultiplayerGamePlayingStatus: MultiplayerGameStatus, GameMessages {
    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        discardMessage(message)
    }

    override func initPlayerMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func scheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        forwardMessageToController(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        queueMessageForProcessingLater(message)
    }
}

class MultiplayerGameDidEndStatus: MultiplayerGameStatus, GameMessages {
    override func testMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func didShowGameViewController(message: MPCMessage) {
        discardMessage(message)
    }

    override func initPlayerMessage(message: MPCMessage) {
        discardMessage(message)
    }

    override func scheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func didScheduleGame(message: MPCMessage) {
        discardMessage(message)
    }

    override func elementDidMoveMessage(message: MPCMessage) {
//        discardMessage(message)
    }

    override func playerDidCrash(message: MPCMessage) {
        discardMessage(message)
    }

    override func gameDidEnd(message: MPCMessage) {
        forwardMessageToController(message)
    }
}