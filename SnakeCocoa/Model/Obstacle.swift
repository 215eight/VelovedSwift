//
//  Obstacle.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

struct Obstacle: StageLocatable, Equatable {
    
    // MARK: Properties
    var location: StageLocation
    
}

func ==(left: Obstacle, right: Obstacle) -> Bool {
    return left.location == right.location
}

func !=(left: Obstacle, right: Obstacle) -> Bool {
    return !(left == right)
}