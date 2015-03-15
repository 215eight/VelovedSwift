//
//  Stage.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class Stage: NSObject, AppleDelegate {
    
    // MARK: Properties
    var size: StageSize
    var obstacles: [Obstacle]
    var loopHoles: [LoopHole]
    var apples = [Apple : StageLocation]()
    var snakes = [Snake]()
    
    init(configurator: StageConfigurator) {
        size = configurator.size
        obstacles = configurator.obstacles
        loopHoles = configurator.loopHoles
    }
    
    func randomLocation() -> StageLocation {
        let x = Int(arc4random_uniform(UInt32(size.width)))
        let y = Int(arc4random_uniform(UInt32(size.height)))
        var location = StageLocation(x: x, y: y)
        
        if contains(location) { location = randomLocation() }
        
        return location
    }
    
    func addApple(apple: Apple) -> StageLocation {
        let location = randomLocation()
        apples[apple] = location
        return location
    }
    
    func contains(location: StageLocation) -> Bool {
        return obstacles.map({ $0.location }).contains(location) ||
               loopHoles.map({ $0.location }).contains(location) ||
               apples.values.array.contains(location)
    }
    
    
    // MARK: Apple delegate methods
    func updateAppleLocation(apple: Apple) -> StageLocation {
        return addApple(apple)
    }
}