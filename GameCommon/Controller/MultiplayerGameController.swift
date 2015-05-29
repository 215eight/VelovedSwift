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
    var ackCounter = 0
    var status: MultiplayerGameStatus!

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

    public override func startGame() {
        status = MultiplayerGameModelInitStatus(controller: self)
        let didShowGameViewControllerMsg = MPCMessage.getDidShowGameViewControllerMessage()
        MPCController.sharedMPCController.sendMessage(didShowGameViewControllerMsg)
    }

    public override func setUpModel() {

        initStage()

        if isMyInitializationTurn() {
            initializePlayer()
        }
    }

    func initStage() {
        let stageConfigurator = StageConfiguratorLevel1(size: DefaultStageSize)
        stage = Stage.sharedStage
        stage.configurator = stageConfigurator
        stage.delegate = self
    }

    func isMyInitializationTurn() -> Bool {

        if let players = stage.elements[Player.elementName] {
            if players.count == MPCController.sharedMPCController.precedence {
                return true
            }
        } else if MPCController.sharedMPCController.isHighestPrecedence {
                return true
        }

        return false
    }

    func initializePlayer() {

        let playerDirection = Direction.randomDirection()
        let playerLocations = stage.randomLocations(DefaultPlayerSize, direction: playerDirection)
        let playerType = PlayerType(rawValue: UInt(MPCController.sharedMPCController.precedence))!

        let playerConfig = PlayerConfiguration(locations: playerLocations,
            direction: playerDirection,
            type: playerType)

        let initPlayerMsg = MPCMessage.getInitPlayerMessage(playerConfig)

        MPCController.sharedMPCController.sendMessage(initPlayerMsg)

        let player = initializePlayerWithConfiguration(playerConfig)

        playerController = PlayerController(bindings: KeyboardControlBindings())
        playerController.registerPlayer(player)
    }

    func initializePlayerWithConfiguration(playerConfiguration: PlayerConfiguration) -> Player {

        let player = Player(locations: playerConfiguration.locations,
            direction: playerConfiguration.direction)
        player.type = playerConfiguration.type
        player.delegate = stage
        stage.addElement(player)

        return player
    }

    func areAllPlayersInitialized() -> Bool {
        if let players = stage.elements[Player.elementName] {
            if players.count > MPCController.sharedMPCController.getConnectedPeers().count {
                return true
            }
        }
        return false
    }
}

extension MultiplayerGameController: StageDelegate {
    func elementLocationDidChange(element: StageElement, inStage stage: Stage) {

    }

    func validateGameLogicUsingElement(element: StageElement, inStage stage: Stage) {

    }
}

extension MultiplayerGameController: GameMessages {

    func testMessage(message: MPCMessage) {
        // Do nothing
    }

    func didShowGameViewController(message: MPCMessage) {

        if MPCController.sharedMPCController.isHighestPrecedence {
            ackCounter++
            if ackCounter == MPCController.sharedMPCController.getConnectedPeers().count {
                ackCounter = 0
                setUpModel()
            }
        }
    }

    func initPlayerMessage(message: MPCMessage) {

        if stage == nil {
            initStage()
        }

        if let body = message.body {
            if let playerConfig = body[MPCMessageKey.PlayerConfig.rawValue] as? PlayerConfiguration {
                initializePlayerWithConfiguration(playerConfig)
            }
        }

        if areAllPlayersInitialized() {
            status = MultiplayerGameViewInitStatus(controller: self)
            dispatch_async(dispatch_get_main_queue()) {
                self.setUpView()
            }
        } else if isMyInitializationTurn() {
            initializePlayer()
            if areAllPlayersInitialized() {
                status = MultiplayerGameStatus(controller: self)
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUpView()
                }
            }
        }
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