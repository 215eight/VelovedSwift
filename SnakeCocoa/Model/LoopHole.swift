//
//  LoopHole.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class useless : NSObject {
    var t: LoopHole!
}

struct LoopHole: StageLocatable {
    
    // MARK: Properties
    
    var location: StageLocation
    private var _targets = [Direction : StageLocatable]()
    var targets : [Direction : StageLocatable] {
        return _targets
    }
    
    // MARK: Initializers
    
    init(location: StageLocation) {
        self.location = location
    }
    
    // MARK: Instance Methods
    
    func destinationLocation(direction: Direction) -> StageLocation {
        
        if let stageLocatable = targets[direction]{
            return stageLocatable.location
        }
        
       return location.destinationLocation(direction)
    }
    
    mutating func addTarget(target: StageLocatable, forDirection: Direction) {
        _targets[forDirection] = target
    }
}