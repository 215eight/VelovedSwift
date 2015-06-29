//
//  PlayerConfigurationGenerator.swift
//  VelovedGame
//
//  Created by eandrade21 on 5/10/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public enum PlayerType: UInt {
    case Solid
    case Squared
    case Dots
    case Stripes

}

struct PlayerTypeGenerator: GeneratorType {
    private var index: UInt = 0
    mutating func next() -> PlayerType? {
        let type = PlayerType(rawValue: index)
        index++
        return type
    }
}

struct PlayerConfigurationGenerator: GeneratorType {

    let stage: Stage
    let bodySize: Int
    var typeGenerator: PlayerTypeGenerator

    init(stage: Stage) {
        self.stage = stage
        self.bodySize = DefaultPlayerSize
        self.typeGenerator = PlayerTypeGenerator()
    }

    mutating func next() -> PlayerConfiguration? {

        if let type = typeGenerator.next() {

            let direction = Direction.randomDirection()
            let locations = stage.randomLocations(bodySize, direction: direction)

            let player = Player(locations: locations, direction: direction)
            stage.addElement(player)

            return PlayerConfiguration(locations: locations, direction: direction, type: type)
            
        } else {
            return nil
        }
    }

    func cleanUpStage() {
        stage.removeElementsOfType(Player.elementName)
    }
}
