//
//  StageConfigurator.swift
//  SnakeSwift
//
//  Created by eandrade21 3/12/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class StageConfiguratorLevel1Test: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProperties_10x10() {
        
        // Create a StageConfigurator
        let size = StageSize(width: 10, height: 10)
        let stageConfigurator = StageConfiguratorLevel1(size: size)
        let coordinateIntersection = stageConfigurator.obstacles.intersects(stageConfigurator.loopHoles)
        
        // Validate properties
        XCTAssertEqual(stageConfigurator.obstacles.count, 38, "Stage should have 38 obstacles")
        XCTAssertEqual(stageConfigurator.loopHoles.count, 0, "Stage should have 0 loopHoles")
        XCTAssertEqual(coordinateIntersection, [], "Obstacles and loopHoles should not intersect")
        
    }

}
