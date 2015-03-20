//
//  StageElement.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class StageElement: NSObject, StageLocatable, Equatable {
    
    var locations: [StageLocation]
    
    init(locations: [StageLocation]) {
        self.locations = locations
    }
}

func ==(left: StageElement, right: StageElement) -> Bool {
    return left.locations == right.locations
}

func !=(left: StageElement, right: StageElement) -> Bool {
    return !(left == right)
}