//
//  StageElement.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class StageElement: NSObject, StageLocatable {
    
    var locations: [StageLocation]
    
    init(locations: [StageLocation]) {
        self.locations = locations
        super.init()
    }
    
    convenience override init() {
        let zeroLocation = StageLocation(x: 0, y: 0)
        self.init(locations: [zeroLocation])
    }
    
}

func ==(left: StageElement, right: StageElement) -> Bool {
    return left.locations == right.locations
}

func !=(left: StageElement, right: StageElement) -> Bool {
    return !(left == right)
}

protocol StageElementDelegate: class {
    func randomLocations(positions: Int) -> [StageLocation]
    func randomLocations(positions: Int, direction: Direction) -> [StageLocation]
    func destinationLocation(location: StageLocation, direction: Direction) -> StageLocation
    func elementLocationDidChange(element: StageElement)
}