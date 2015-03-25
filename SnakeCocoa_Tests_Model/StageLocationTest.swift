//
//  StageLocationTest.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class StageLocationTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

   func testStageLocationProperties() {
        // Create a new StageLocation
        let sl = StageLocation(x: 10, y:20)
        
        // Validate property values
        XCTAssertEqual(sl.x, Int(10), "Property incorrectly initialized")
        XCTAssertEqual(sl.y, Int(20), "Property incorrectly initialized")
        XCTAssertEqual(sl.location.0, Int(10), "Incorrect calculated property")
        XCTAssertEqual(sl.location.1, Int(20), "Incorrect calculated property")
    }
    
    func testPropertyShouldBeGreaterThanZero() {
        
        //Create a new StageLocation
        let sl = StageLocation(x: -10, y: -10)
        
        // Validate property values
        XCTAssertEqual(sl.x, Int(0), "Property incorrectly initialized")
        XCTAssertEqual(sl.y, Int(0), "Property incorrectly initialized")
    }
    
    func testIsPrintable() {
        
        // Create a new StageLocation
        let sl = StageLocation(x: 30, y: 30)
        
        // Validate is printable
        XCTAssertEqual(sl.description, "Stage Location x: 30 y: 30", "Incorrect property description")
    }
    
    func testDestinationLocation() {
        
        // Create a new StageLocation
        let sl = StageLocation(x:10, y:10)
        let up = StageLocation(x:10, y:9)
        let down = StageLocation(x:10, y:11)
        let left = StageLocation(x:9, y:10)
        let right = StageLocation(x:11, y:10)
        
        // Validate destination location
        XCTAssertEqual(sl.destinationLocation(Direction.Up), up, "Incorrect destination location")
        XCTAssertEqual(sl.destinationLocation(Direction.Down), down, "Incorrect destination location")
        XCTAssertEqual(sl.destinationLocation(Direction.Left), left, "Incorrect destination location")
        XCTAssertEqual(sl.destinationLocation(Direction.Right), right, "Incorrect destination location")
    }
    
    func testComparison(){
        let x0y0 = StageLocation(x: 0, y: 0)
        let x9y9 = StageLocation(x: 9, y: 9)
        let x9y0 = StageLocation(x: 9, y: 0)
        let x0y9 = StageLocation(x: 0, y: 9)
        
        XCTAssertTrue(x0y0 < x9y0, "Less")
        XCTAssertTrue(x9y0 < x0y9, "Less")
        XCTAssertTrue(x0y9 < x9y9, "Less")
        XCTAssertFalse(x0y0 < x0y0, "Equal")
        XCTAssertFalse(x0y0 > x0y0, "Equal")
    }
}
