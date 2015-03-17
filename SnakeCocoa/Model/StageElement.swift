//
//  StageElement.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class StageElement: NSObject, StageLocatable, Equatable {
    
    var location: StageLocation?
    
    init(location: StageLocation?) {
        self.location = location
    }
}

func ==(left: StageElement, right: StageElement) -> Bool {
    return left.location == right.location
}

func !=(left: StageElement, right: StageElement) -> Bool {
    return !(left == right)
}

enum StageElementType {
    case Obstacle
    case LoopHole
    case Apple
    case Snake
    
    func getStageElementType(element: StageElement) {
       
    }
}