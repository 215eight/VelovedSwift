//
//  OSX_StageViewTransformTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class OSX_StageViewTransformTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {

        let win = CGRect(x: 0, y: 0, width: 3200, height: 1800)
        let mac_svt = OSX_StageViewTransform(frame: win)

        XCTAssertEqual(mac_svt.calculateScaleFactor(), CGFloat(1800.0/32.0), "Scale factor")
        XCTAssertEqual(mac_svt.getStageFrame(), win, "Stage is the same size as the frame passed in the constructor")
    }

    func testGetFrame() {

        let win = CGRect(x: 0, y: 0, width: 3200, height: 1800)
        let mac_svt = OSX_StageViewTransform(frame: win)
        var location = StageLocation.zeroLocation()
        var frame = mac_svt.getFrame(location)

        var testOrigin = CGPointZero
        var testSize = CGSize(width: 1800.0/32.0, height: 1800.0/32.0)
        XCTAssertEqual(frame.origin, testOrigin, "Origin x:0 y:0")
        XCTAssertEqual(frame.size, testSize, "Size = scale factor")

        location = StageLocation(x: 31, y: 55)
        let originX = CGFloat(location.y) * 1800.0/32.0
        let originY = CGFloat(location.x) * 1800.0/32.0
        testOrigin = CGPoint(x: originX, y: originY)

        frame = mac_svt.getFrame(location)
        XCTAssertEqual(frame.origin, testOrigin, "Origin equal top right corner")
        XCTAssertEqual(frame.size, testSize, "Size = scale factor")
    }

    func testGetDirection() {
        let win = CGRect(x: 0, y: 0, width: 3200, height: 1800)
        let mac_svt = OSX_StageViewTransform(frame: win)

        XCTAssertEqual(mac_svt.getDirection(.Up), Direction.Up, "Direction should not be transformed")
    }
}
