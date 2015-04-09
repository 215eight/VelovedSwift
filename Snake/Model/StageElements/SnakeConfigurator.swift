//
//  SnakeConfigurator.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/5/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

enum SnakeType: UInt {
    case Solid
    case Squared
    case Dots
}

struct SnakeTypeGenerator: GeneratorType {
    private var index: UInt = 0
    mutating func next() -> SnakeType? {
        let type = SnakeType(rawValue: index)
        index++
        return type
    }
}

struct SnakeConfigurator {
    
    private let stage: Stage
    private let bodySize: Int
    private var typeGenerator: SnakeTypeGenerator

    init (stage: Stage, bodySize: Int, typeGenerator: SnakeTypeGenerator) {
        self.stage = stage
        self.bodySize = bodySize
        self.typeGenerator = typeGenerator
    }
    
    mutating func getSnake() -> Snake? {
        
        if let type = typeGenerator.next() {
            let randDirection = Direction.randomDirection()
            let randLocations = stage.randomLocations(bodySize, direction: randDirection)
            let snake = Snake(locations: randLocations, direction: randDirection)
            snake.type = type
            
            return snake
            
        } else {
            return nil
        }
    }
}