//
//  SnakeConfigurator.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/5/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

struct SnakeConfigurator {
    
    private let stage: Stage

    init (stage: Stage ) {
        self.stage = stage
    }
    
    func configureSnakes(snakeConfigMap: [String : SnakeConfiguration], snakeController: SnakeController) -> [String : Snake]{

        var snakeMap = [String : Snake]()

        for (peerName, snakeConfig) in snakeConfigMap {
            var snake: Snake
            if peerName == MPCController.sharedMPCController.peerID.displayName {
                snake = SnakeLocal(locations: snakeConfig.locations,
                    direction: snakeConfig.direction)
                snakeController.registerSnake(snake)
                
            } else {
                snake = SnakeRemote(locations: snakeConfig.locations,
                    direction: snakeConfig.direction)
            }
            snake.type = snakeConfig.type
            snake.delegate = stage
            stage.addElement(snake)
            snakeMap[peerName] = snake
        }

        return snakeMap
    }
}