//
//  MultiplayerMasterSnakeGameController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/27/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class MultiplayerMasterSnakeGameController: MultiplayerSnakeGameController {

    public override func setUpModel() {
        super.setUpModel()

        var snakeMap = [String : SnakeConfiguration]()

        let typeGenerator = SnakeTypeGenerator()
        var snakeConfigurationGenerator = SnakeConfigurationGenerator(stage: stage)

        snakeMap[MPCController.sharedMPCController.peerID.displayName] = snakeConfigurationGenerator.next()

        let connectedPeers = MPCController.sharedMPCController.getConnectedPeers()
        for peer in connectedPeers {
            snakeMap[peer.displayName] = snakeConfigurationGenerator.next()
        }

        snakeConfigurationGenerator.cleanUpStage()

        let setUpSnakeMsg = MPCMessage.getSetUpSnakesMessage(snakeMap)
        MPCController.sharedMPCController.sendMessage(setUpSnakeMsg)

        setUpSnakes(snakeMap)
    }

    public override func scheduleGame() {
        let gameStartDate = NSDate(timeIntervalSinceNow: DefaultGameStartDelay)
        let gameStartDateTimeInterval = gameStartDate.timeIntervalSince1970
        let gameStartDateTimeIntervalStr = String(format: "%f", gameStartDateTimeInterval)
        let scheduleGameMsg = MPCMessage.getScheduleGameMessage(gameStartDateTimeIntervalStr)

        MPCController.sharedMPCController.sendMessage(scheduleGameMsg)

        scheduleGameStart(gameStartDateTimeIntervalStr)
    }
}