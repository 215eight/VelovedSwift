//
//  OSX_StageViewTransformTests.swift
//  SnakeSwift
//
//  Created by eandra21 on 4/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import SnakeCommon

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

        // DefaultStageSize dimensions are based on a portrait orientaion
        // Since OSX is always landscape, dimensions are switched to calculate the scale factor
        let scaleFactor: CGFloat = 1800.0 / CGFloat(DefaultStageSize.width)

        // Frame needs to be centered and scaled so it fits in window
        let scaledWin = CGRect(x: 25.0, y:0.0, width: 3150.0, height: 1800.0)

        XCTAssertEqual(mac_svt.calculateScaleFactor(), scaleFactor, "Scale factor is equal to the min width or height ratio")
        XCTAssertEqual(mac_svt.getStageFrame(), scaledWin, "Stage has to be centered and scaled so it fits in the init window")
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

        XCTAssertEqual(mac_svt.getDirection(.Up), Direction.Right, "Up inversed to Right")
        XCTAssertEqual(mac_svt.getDirection(.Down), Direction.Left, "Down inversed to Left")
        XCTAssertEqual(mac_svt.getDirection(.Right), Direction.Down, "Right reversed to Left then inversed to Down")
        XCTAssertEqual(mac_svt.getDirection(.Left), Direction.Up, "Left reversed to Right then inversed to Up")
    }
}
