//
//  SinglePlayerGameController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

public class SinglePlayerGameController: GameController {

    override public func startGame() {
        setUpModel()
        setUpView()
        animateStage()
    }

    override public func setUpModel() {
        let stageConfigurator = StageConfiguratorLevel1(size: DefaultStageSize)
        stage = Stage.sharedStage
        stage.configurator = stageConfigurator
        stage.delegate = self

        // TODO: Move this to the level configurator
        let targetLocations = stage.randomLocations(DefaultTargetSize)
        let target = Target(locations: targetLocations, value: DefaultTargetValue)
        target.delegate = stage
        stage.addElement(target)

        var playerConfigurationGenerator = PlayerConfigurationGenerator(stage: stage)
        let playerConfiguration = playerConfigurationGenerator.next()!
        playerConfigurationGenerator.cleanUpStage()

        let player = Player(locations: playerConfiguration.locations,
            direction: playerConfiguration.direction)
        player.type = playerConfiguration.type
        player.delegate = stage
        stage.addElement(player)

        playerController = PlayerController(bindings: KeyboardControlBindings())
        playerController.registerPlayer(player)

    }

}

extension SinglePlayerGameController: StageDelegate {

    func broadcastElementDidMoveEvent(locations: [StageLocation], direction: Direction?) {
        // No other players. Do nothing
    }
    func elementLocationDidChange(element: StageElement, inStage stage: Stage) {
        viewController?.drawElement(element)
    }

    func validateGameLogicUsingElement(element: StageElement, inStage stage: Stage) {
        if let player = element as? Player {
            if stage.didPlayerCrash(player) ||  stage.didPlayerEatItself(player) {
                player.kill()
                self.elementLocationDidChange(element, inStage: stage)
                restartGame()
            }else {
                if let target = stage.didPlayerSecureTarget(player) {
                    target.wasSecured()
                    player.didSecureTarget()
                }
            }
        }
    }
}