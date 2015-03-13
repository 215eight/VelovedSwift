//
//  StageLocation.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

struct StageLocation {
    
    var x: Float
    var y: Float
    
    var location: (Float, Float) {
        get {
            return (x, y)
        }
    }
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}

func == (left: StageLocation, right: StageLocation) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}

func != (left: StageLocation, right: StageLocation) -> Bool {
    return !(left == right)
}

protocol StageLocatable {
    var location: StageLocation { get set }
}