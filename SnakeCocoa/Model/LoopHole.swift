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
    var _targets = [Direction : LoopHole]()
    var targets : [Direction : LoopHole] {
        return _targets
    }
    
    // MARK: Initializers
    
    init(location: StageLocation) {
        self.location = location
    }
    
    // MARK: Instance Methods
    
    func destinationLocation(direction: Direction) -> StageLocation {
        
        var destinationX: Float = location.x
        var destinationY: Float = location.y
        
        switch direction {
        case .Up:
            destinationY -= 1
        case .Down:
            destinationY += 1
        case .Left:
            destinationX -= 1
        case .Right:
            destinationX += 1
        }
        
        return StageLocation(x: destinationX, y: destinationY)
    }
    
    func addTarget(target: LoopHole, forDirection: Direction) {
        
    }
}