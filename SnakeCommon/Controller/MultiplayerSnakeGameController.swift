//
//  MultiplayerSnakeGameController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class MultiplayerSnakeGameController: SnakeGameController {


    override public func startGame() {
        setUpModel()
        setUpView()
        scheduleGame()
    }

    override public func setUpModel() {
        let stageConfigurator = StageConfiguratorLevel1(size: DefaultStageSize)
        stage = Stage.sharedStage
        stage.configurator = stageConfigurator
        stage.delegate = self

        snakeController = SnakeController(bindings: KeyboardControlBindings())

    }

    func scheduleGame() {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    public override func setUpApples(appleConfigMap: [String : AppleConfiguration]) {
        let appleConfigurator = AppleConfigurator(stage: stage)
        appleMap = appleConfigurator.configureApples(appleConfigMap)
    }

    override public func setUpSnakes(snakeConfigMap: [String : SnakeConfiguration]) {
        let snakeConfigurator = SnakeConfigurator(stage: stage)
        snakeMap = snakeConfigurator.configureSnakes(snakeConfigMap, snakeController: snakeController)
    }

    override public func scheduleGameStart(gameStartDate: String) {

        let gameStartDateTimeInterval = (gameStartDate as NSString).doubleValue

        let futureDate = NSDate(timeIntervalSince1970: gameStartDateTimeInterval)

        var futureDateSpec = timespec(tv_sec: Int(futureDate.timeIntervalSince1970), tv_nsec: 0)

        dispatch_after(dispatch_walltime(&futureDateSpec, 0), dispatch_get_main_queue()){
            self.animateStage()
        }
    }
}

extension MultiplayerSnakeGameController: StageDelegate {
    func elementLocationDidChange(element: StageElement, inStage stage: Stage) {
        viewController.drawElement(element)
    }

    func validateGameLogicUsingElement(element: StageElement, inStage stage: Stage) {
        if let snake = element as? Snake {
            if stage.didSnakeCrash(snake) ||  stage.didSnakeEatItself(snake) {
                snake.kill()
                elementLocationDidChange(element, inStage: stage)

                if snakeMap[MPCController.sharedMPCController.peerID.displayName] === snake {
                    viewController.showModalMessage()
                }

                if stage.snakesAlive() <= 1 {
                    restartGame()
                }
            }else {
                if let apple = stage.didSnakeEatAnApple(snake) {
                    apple.wasEaten()
                    snake.didEatApple()
                }
            }
        }
    }
}

extension MultiplayerSnakeGameController: MPCControllerDelegate {

    public func didUpdatePeers() {
        
    }

    public func didReceiveMessage(msg: MPCMessage) {

        switch msg.event {
        case .SetUpApples:
            setUpApples(msg)
        case .SetUpSnakes:
            setUpSnakes(msg)
        case .ScheduleGame:
            scheduleGameStart(msg)
        case .SnakeDidChangeDirection:
            updateRemoteSnakeDirection(msg)
        case .AppleDidChangeLocation:
            updateRemoteAppleLocations(msg)
        default:
            break
        }
    }

    func setUpApples(msg: MPCMessage) {
        if let appleConfigMap = msg.body as? [String : AppleConfiguration] {
            setUpApples(appleConfigMap)
        }
        viewController?.drawViews() //Investigate
    }

    func setUpSnakes(msg: MPCMessage) {
        if let snakeConfigMap = msg.body as? [String : SnakeConfiguration] {
            setUpSnakes(snakeConfigMap)
        }
        viewController?.drawViews() // Investigate
    }

    func scheduleGameStart(msg: MPCMessage) {
        if let body = msg.body {
            if let gameStartDate = body[MPCMessageKey.GameStartDate.rawValue] as? String {
                scheduleGameStart(gameStartDate)
            }
        }
    }

    func updateRemoteSnakeDirection(msg: MPCMessage) {
        if let body = msg.body {
            if let directionDesc = body[MPCMessageKey.SnakeDirection.rawValue] as? String {
                let direction = Direction(rawValue: UInt8(directionDesc.toInt()!))!
                updateRemoteSnakeDirection(msg.sender, newDirection: direction)
            }
        }
    }

    func updateRemoteAppleLocations(msg: MPCMessage) {
        if let body = msg.body {
            if let locationsSerialiazable = body[MPCMessageKey.Locations.rawValue] as? [StageLocationSerializable] {
                let locations = locationsSerialiazable.map() {
                    StageLocation(x: Int($0.x), y: Int($0.y))
                }
                updateRemoteAppleLocations(Apple.elementName, locations: locations)
            }
        }
    }
}