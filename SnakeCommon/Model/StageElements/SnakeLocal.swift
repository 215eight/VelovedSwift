//
//  SnakeLocal.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/9/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

class SnakeLocal: Snake {

    override func stageElementDirectionDidChange() {
        super.stageElementDirectionDidChange()

        let snakeDidChangeDirectionMsg = MPCMessage.getSnakeDidChangeDirection(direction)
        MPCController.sharedMPCController.sendMessage(snakeDidChangeDirectionMsg)
    }
}