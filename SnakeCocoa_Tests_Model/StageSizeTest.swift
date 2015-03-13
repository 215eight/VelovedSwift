//
//  StageSize.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/12/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class StageSizeTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPorperites() {
        
        // Create Stage Size
        let stageSize = StageSize(width: 50, height: 70)
        
        
        // Validate properties
        XCTAssertEqual(stageSize.width, Int(50), "Property incorrectly initialized")
        XCTAssertEqual(stageSize.height, Int(70), "Property incorrectly initialized")
    }
    
    func testPropertiesCantBeNegative() {
        
        // Create StageSize
        let stageSize = StageSize(width: -10, height: -10)
        
        // Validate properties
        XCTAssertEqual(stageSize.width, Int(0), "Property should be greater than zero")
        XCTAssertEqual(stageSize.height, Int(0), "Property should be greater than zero")
    }
    
    func testIsPrintable() {
        
        // Create StageSize
        let stageSize = StageSize(width: 0, height: 0)
        
        // Validate confromance
        XCTAssertEqual(stageSize.description, "Stage Size: x: 0 y: 0", "Class description string doesn't match")
    }
}
