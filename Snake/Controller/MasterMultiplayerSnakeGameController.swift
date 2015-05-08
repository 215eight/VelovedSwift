//
//  MasterMultiplayerSnakeGameController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/27/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class MultiplayerMasterSnakeGameController: MultiplayerSnakeGameController {

    override func scheduleGame() {
        let scheduleDate: NSDate = NSDate(timeIntervalSinceNow: 3)
        var scheduleTimeInterval = scheduleDate.timeIntervalSinceReferenceDate
        let startTimeStr: String = String(format: "%f", arguments: [scheduleTimeInterval])
        let scheduleGameMsg = MPCMessage.getScheduleGameMessage(startTimeStr)
        MPCController.sharedMPCController.sendMessage(scheduleGameMsg)
    }
}