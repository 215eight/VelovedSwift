//
//  OSX_WindowResizerTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit
import XCTest

class OSX_WindowResizerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testResizeWindowProportionalToScreenResolution() {
        let testScreen = CGRect(x: 0, y: 0, width: 3200, height: 1800)
        let scaledScreen = OSX_WindowResizer.resizeWindowProportionalToScreenResolution(0.8)

        XCTAssert(scaledScreen?.origin.x == CGFloat(320.0), "Origin X = 320. Actual Value: \(scaledScreen!.origin.x)")
        XCTAssert(scaledScreen?.origin.y == CGFloat(180.0), "Origin Y = 180. Actual Value: \(scaledScreen!.origin.y)")
        XCTAssert(scaledScreen?.size.width == CGFloat(2560.0), "Size width = 2560. Actual Value: \(scaledScreen?.size.width)")
        XCTAssert(scaledScreen?.size.height == CGFloat(1440.0), "Size height = 1440. Actual Value: \(scaledScreen?.size.height)")
    }
}
