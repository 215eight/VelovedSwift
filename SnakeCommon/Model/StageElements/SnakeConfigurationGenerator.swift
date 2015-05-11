//
//  SnakeConfigurationGenerator.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/10/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public enum SnakeType: UInt {
    case Solid
    case Squared
    case Dots
    case Stripes

}

struct SnakeTypeGenerator: GeneratorType {
    private var index: UInt = 0
    mutating func next() -> SnakeType? {
        let type = SnakeType(rawValue: index)
        index++
        return type
    }
}

struct SnakeConfigurationGenerator: GeneratorType {

    let stage: Stage
    let bodySize: Int
    var typeGenerator: SnakeTypeGenerator

    init(stage: Stage) {
        self.stage = stage
        self.bodySize = DefaultSnakeSize
        self.typeGenerator = SnakeTypeGenerator()
    }

    mutating func next() -> SnakeConfiguration? {

        if let type = typeGenerator.next() {

            let direction = Direction.randomDirection()
            let locations = stage.randomLocations(bodySize, direction: direction)

            let snake = Snake(locations: locations, direction: direction)
            stage.addElement(snake)

            return SnakeConfiguration(locations: locations, direction: direction, type: type)
            
        } else {
            return nil
        }
    }

    func cleanUpStage() {
        stage.removeElementsOfType(Snake.elementName)
    }
}
