//
//  Tunnel.swift
//  GameSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class Tunnel: StageElement {
    
    // MARK: Properties

    override public class var elementName: String {
        return "Tunnel"
    }
    
    private var _targets = [Direction : StageElement]()
    var targets : [Direction : StageElement] {
        return _targets
    }
    
    // MARK: Initializers
    
    override init(locations: [StageLocation]) {
        
        if locations.isEmpty || locations.count > 1 {
            assertionFailure("Tunnel must have one and only one location")
        }
        
        super.init(locations: locations)
    }
    
    // MARK: Instance Methods
    
    func destinationLocation(direction: Direction) -> StageLocation {
        
        if let stageElement = targets[direction] {
            return stageElement.locations.first!
        }
        
       return locations.first!.destinationLocation(direction)
    }
    
    func addTarget(target: StageElement, forDirection: Direction) {
        
        if target.locations.isEmpty || target.locations.count > 1 {
            assertionFailure("Tunnel targets must have one and only one location")
        }
        
        _targets[forDirection] = target
    }
}

