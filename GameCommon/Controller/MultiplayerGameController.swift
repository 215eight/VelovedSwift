//
//  MultiplayerGameController.swift
//  GameSwift
//
//  Created by eandrade21 on 5/25/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import MultipeerConnectivity

public class MultiplayerGameController: GameController{

    var messageQueue = [MPCMessage]()
    var status: MultiplayerGameStatus!
    var turn: Int!

    public override init() {
        super.init()
        status = MultiplayerGameIdleStatus(controller: self)

        let myPeer = MPCController.sharedMPCController.peerID
        let allPeers = MPCController.sharedMPCController.getConnectedPeers()
        turn = self.setTurn(myPeer, allPeers: allPeers)
    }

    func processMessage(message: MPCMessage) {
        status.processMessage(message)
    }

    func queueMessage(message: MPCMessage) {
        messageQueue.append(message)
    }

    func dequeueMessage() -> MPCMessage? {
        if !messageQueue.isEmpty {
            return messageQueue.removeAtIndex(0)
        }
        return nil
    }

    func setTurn(myPeer: MCPeerID, allPeers: [MCPeerID]) -> Int {

        var _allPeers = allPeers
        _allPeers.sort( { $0.hash < $1.hash } )

        var turn = 0
        for peer in _allPeers {
            if myPeer == peer { break }
            turn++
        }

        return turn
    }

}

extension MultiplayerGameController: GameMessages {
    func testMessage(message: MPCMessage) {
        // Do nothign for now
    }
}

extension MultiplayerGameController: MPCControllerDelegate {
    public func didUpdatePeers() {
        // Do nothing for now
    }

    public func didReceiveMessage(message: MPCMessage) {
        processMessage(message)
    }
}