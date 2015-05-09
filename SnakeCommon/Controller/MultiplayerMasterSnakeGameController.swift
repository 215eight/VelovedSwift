//
//  MultiplayerMasterSnakeGameController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/27/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import SnakeCommon

public class MultiplayerMasterSnakeGameController: MultiplayerSnakeGameController {

    public override func scheduleGame() {
        let gameStartDate = NSDate(timeIntervalSinceNow: DefaultGameStartDelay)
        let gameStartDateTimeInterval = gameStartDate.timeIntervalSince1970
        let gameStartDateTimeIntervalStr = String(format: "%f", gameStartDateTimeInterval)
        let scheduleGameMsg = MPCMessage.getScheduleGameMessage(gameStartDateTimeIntervalStr)

        MPCController.sharedMPCController.sendMessage(scheduleGameMsg)

        scheduleGameStart(gameStartDateTimeIntervalStr)
    }
}