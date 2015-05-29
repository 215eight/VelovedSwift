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
    lazy var turn: Int = self.setTurn()

    public override init() {
        super.init()
        status = MultiplayerGameIdleStatus(controller: self)
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

    func setTurn() -> Int {
        let myself = MPCController.sharedMPCController.peerID
        let connectedPeers = MPCController.sharedMPCController.getConnectedPeers()

        return setTurn(myself, allPeers: connectedPeers)
    }

    func setTurn(myPeer: MCPeerID, allPeers: [MCPeerID]) -> Int {

        var _allPeers = allPeers
        _allPeers.sort( { $0.hash < $1.hash } )

        var turn = 0
        var found = false
        for peer in _allPeers {
            if myPeer == peer {
                found = true
                break
            }
            turn++
        }

        if !found {
            assertionFailure("Peer isn't part of the connected peers")
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