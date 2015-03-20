//
//  ObstacleTest.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class ObstacleTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProperties() {
        
        // Create an Obstacle
        let l = StageLocation(x:0, y:0)
        let o = Obstacle(locations:[l])
        
        // Validate property
        XCTAssertTrue(o.locations.first! == l, "Property incorrectly initialized")
    }
    
}
