//
//  StageLocation.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

struct StageLocation: Printable, Equatable {
    
    var x: Int = 0
    var y: Int = 0
    
    var location: (Int, Int) {
        get {
            return (x, y)
        }
    }
    
    var description: String {
        return "Stage Location x: \(x) y: \(y)"
    }
    
    init(x: Int, y: Int) {
        if x > 0 { self.x = x }
        if y > 0 { self.y = y }
    }
    
    func destinationLocation(direction: Direction) -> StageLocation {

        var newX = self.x
        var newY = self.y
        
        switch direction {
        case .Up:
            newY -= 1
        case .Down:
            newY += 1
        case .Left:
            newX -= 1
        case .Right:
            newX += 1
        }
        
        return StageLocation(x: newX, y: newY)
    }
}

func == (left: StageLocation, right: StageLocation) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}

func != (left: StageLocation, right: StageLocation) -> Bool {
    return !(left == right)
}

protocol StageLocatable: Equatable {
    var location: StageLocation? { get }
}