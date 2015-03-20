//
//  StageElementTests.swift
//  SnakeSwift
//
//  Created by PartyMan on 3/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import XCTest

class StageElementTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEqualityEmptyLocations() {
        
        let a = StageElement(locations: [])
        let b = StageElement(locations: [])
        let c = StageElement(locations: [StageLocation(x: 0, y: 0)])
        
        XCTAssertTrue(a == b, "Both elements have no locations")
        XCTAssertFalse(a == c, "Elements have different number of locations")
    }
    
    func testEqualityNonEmptyElements() {
        let loc1 = StageLocation(x: 0, y: 0)
        let loc2 = StageLocation(x: 0, y: 1)
        
        let a = StageElement(locations: [loc1, loc2])
        let b = StageElement(locations: [loc1, loc2])
        let c = StageElement(locations: [loc2, loc1])
        
        XCTAssertEqual(a, b, "Both elements have the same locations")
        XCTAssertNotEqual(a, c, "Even though elements have the same location, the order is different")
    }
}
