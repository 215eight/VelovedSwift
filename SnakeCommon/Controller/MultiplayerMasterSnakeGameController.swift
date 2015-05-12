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

        var appleConfigMap = createAppleConfigurations()
        let setUpAppleMsg = MPCMessage.getSetUpApplesMessage(appleConfigMap)
        MPCController.sharedMPCController.sendMessage(setUpAppleMsg)
        setUpApples(appleConfigMap)

        var snakeConfigMap = createSnakeConfigurations()
        let setUpSnakeMsg = MPCMessage.getSetUpSnakesMessage(snakeConfigMap)
        MPCController.sharedMPCController.sendMessage(setUpSnakeMsg)
        setUpSnakes(snakeConfigMap)

    }

    func createAppleConfigurations() -> [String: AppleConfiguration] {
        var appleConfigMap = [String : AppleConfiguration]()
        let appleLocation = stage.randomLocations(1)
        let appleConfig = AppleConfiguration(locations: appleLocation)
        appleConfigMap[MPCController.sharedMPCController.peerID.displayName] = appleConfig
        return appleConfigMap
    }

    func createSnakeConfigurations() -> [String : SnakeConfiguration] {

        var snakeConfigMap = [String : SnakeConfiguration]()

        let typeGenerator = SnakeTypeGenerator()
        var snakeConfigurationGenerator = SnakeConfigurationGenerator(stage: stage)

        snakeConfigMap[MPCController.sharedMPCController.peerID.displayName] = snakeConfigurationGenerator.next()

        let connectedPeers = MPCController.sharedMPCController.getConnectedPeers()
        for peer in connectedPeers {
            snakeConfigMap[peer.displayName] = snakeConfigurationGenerator.next()
        }

        snakeConfigurationGenerator.cleanUpStage()

        return snakeConfigMap
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