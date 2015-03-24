//
//  StageConfiguratorLevel1.swift
//  SnakeSwift
//
//  Created by enadrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

struct StageConfiguratorLevel1 : StageConfigurator {
    
    let size: StageSize
    
    var elements: [String: [StageElement]]{
        
        var _elements = [String: [StageElement]]()
        _elements[Obstacle.className()] = obstacles
        _elements[LoopHole.className()] = loopHoles
        return _elements
    }
    
    private var obstacles: [Obstacle] {
        
        var locations = [StageLocation]()
        
        // Generate top and bottom obstacles
        for i in 0 ..< size.width {
            locations.append(StageLocation(x: i, y: 0))
            locations.append(StageLocation(x: i, y: size.height-1))
        }
        
        // Generate left and right obstacles
        
        for i in 1 ..< size.height {
            locations.append(StageLocation(x: 0, y: i))
            locations.append(StageLocation(x: size.width-1, y: i))
        }
        
        return [Obstacle(locations: locations)]
    }
    
    private var loopHoles: [LoopHole] {
        return [LoopHole]()
    }
    
    init(size: StageSize) {
       self.size = size
    }
}
