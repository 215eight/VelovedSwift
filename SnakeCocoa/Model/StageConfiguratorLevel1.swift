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
    
    var obstacles: [Obstacle] {
        
        var _obstacles = [Obstacle]()
        
        // Generate top and bottom obstacles
        for i in 0 ..< size.width {
            let topCoor = StageLocation(x: i, y: 0)
            let bottomCoor = StageLocation(x: i, y: size.height-1)
            
            let topObstacle = Obstacle(location: topCoor)
            let bottomObstacle = Obstacle(location: bottomCoor)
            
            _obstacles.append(topObstacle)
            _obstacles.append(bottomObstacle)
        }
        
        // Generate left and right obstacles
        
        for i in 1 ..< size.height {
            let leftCoor = StageLocation(x: 0, y: i)
            let rightCoor = StageLocation(x: size.width-1, y: i)
            
            let leftObstacle = Obstacle(location: leftCoor)
            let rightObstacle = Obstacle(location: rightCoor)
            
            _obstacles.append(leftObstacle)
            _obstacles.append(rightObstacle)
        }
        
        return _obstacles
    }
    
    var loopHoles: [LoopHole] {
        return [LoopHole]()
    }
    
    init(size: StageSize) {
       self.size = size
    }
}
