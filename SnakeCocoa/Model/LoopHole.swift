//
//  LoopHole.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class LoopHole: StageElement {
    
    // MARK: Properties
    
    private var _targets = [Direction : StageElement]()
    var targets : [Direction : StageElement] {
        return _targets
    }
    
    // MARK: Initializers
    
    init(location: StageLocation) {
        super.init(location: location)
    }
    
    // MARK: Instance Methods
    
    func destinationLocation(direction: Direction) -> StageLocation? {
        
        if let stageElement = targets[direction] {
            if let _location = stageElement.location {
                return _location
            }
        }
        
       return location!.destinationLocation(direction)
    }
    
    func addTarget(target: StageElement, forDirection: Direction) {
        _targets[forDirection] = target
    }
}

