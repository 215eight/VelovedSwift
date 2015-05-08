//
//  DirectionTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/8/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class DirectionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReverseDirection() {

        var reversedDirection = Direction.reversedDirection(.Down)
        XCTAssertTrue(reversedDirection == .Up, "Down reversed to Up")

        reversedDirection = Direction.reversedDirection(.Up)
        XCTAssertTrue(reversedDirection == .Down, "Up reversed to Down")

        reversedDirection = Direction.reversedDirection(.Right)
        XCTAssertTrue(reversedDirection == .Left, "Right reversed to Left")

        reversedDirection = Direction.reversedDirection(.Left)
        XCTAssertTrue(reversedDirection == .Right, "Left reversed to Right")
    }

    func testInvertDirection() {

        var invertedDirection = Direction.inversedDirection(.Right)
        XCTAssertTrue(invertedDirection == .Up, "Inverse of Right is Up")

        invertedDirection = Direction.inversedDirection(.Left)
        XCTAssertTrue(invertedDirection == .Down, "Inverse of Left is Down")

        invertedDirection = Direction.inversedDirection(.Up)
        XCTAssertTrue(invertedDirection == .Right, "Inverse of Up is Right")

        invertedDirection = Direction.inversedDirection(.Down)
        XCTAssertTrue(invertedDirection == .Left, "Inverse of Down is Left")
    }
}
