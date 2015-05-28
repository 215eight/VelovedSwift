//
//  ObstacleTest.swift
//  GameSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class ObstacleTest: XCTestCase {

    func testProperties() {
        
        // Create an Obstacle
        let l = StageLocation(x:0, y:0)
        let o = Obstacle(locations:[l])
        
        // Validate property
        XCTAssertTrue(o.locations.first! == l, "Property incorrectly initialized")
    }
    
}
