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

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    func testStageLocationProperties() {
        // Create a new StageLocation
        let sl = StageLocation(x: 10, y:20)
        
        // Validate property values
        XCTAssertEqual(sl.x, Float(10), "X property incorrectly assigned")
        XCTAssertEqual(sl.y, Float(20), "Y property incorrectly assigned")
        XCTAssertEqual(sl.location.0, Float(10), "Location property incorrectly assigned")
        XCTAssertEqual(sl.location.1, Float(20), "Location property incorrectly assigned")
    }
}
