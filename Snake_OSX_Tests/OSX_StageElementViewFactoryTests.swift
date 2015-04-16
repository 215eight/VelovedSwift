//
//  OSX_StageElementViewFactoryTests.swift
//  SnakeSwift
//
//  Created by PartyMan on 4/15/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa
import XCTest

class OSX_StageElementViewFactoryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStageElementView() {
        let snakeLocations = [StageLocation(x: 10, y: 10),
            StageLocation(x: 10, y: 11),
            StageLocation(x: 10, y: 12),
            StageLocation(x: 10, y: 13),
            StageLocation(x: 10, y: 14)]
        let snake = Snake(locations: snakeLocations, direction: .Up)

        let deviceTransform = OSX_StageViewTransform(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let viewTransform = StageViewTransform(deviceTransform: deviceTransform)

        let factory = OSX_StageElementViewFactory()
        let stageElementView = factory.stageElementView(forElement: snake, transform: viewTransform)

        XCTAssertEqual(stageElementView.views.count, 5, "It should have 5 subviews")
        stageElementView.views.map() { $0 as NSView }
        XCTAssertEqual(stageElementView.views.count, 5, "It should have 5 subviews")

    }
}
