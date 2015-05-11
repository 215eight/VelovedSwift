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
    
    func configureSnakes(snakeMap: [String : SnakeConfiguration], snakeController: SnakeController) {
        for (peerName, snakeConfig) in snakeMap {
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
        }
    }
}