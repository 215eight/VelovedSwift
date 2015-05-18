//
//  GameLobbyController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class GameLobbyController: NSObject {

    private var gamePlayers = [MPCGamePlayer : MPCGamePlayerStatus]()
    
    override init() {
        super.init()
        MPCController.sharedMPCController.delegate = self
    }

}

extension GameLobbyController: MPCControllerDelegate {

    func didFindPlayer(player: MPCGamePlayer) {
        
    }

    func didReceiveMessage(msg: MPCMessage) {

    }
}