//
//  StageConfigurator.swift
//  VelovedGame
//
//  Created by eandrade21 3/12/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class StageConfiguratorLevel1Test: XCTestCase {

    func testProperties_10x10() {
        
        // Create a StageConfigurator
        let size = StageSize(width: 10, height: 10)
        let stageConfigurator = StageConfiguratorLevel1(size: size)
        let obstacles = stageConfigurator.elements[Obstacle.elementName]!
        let tunnels = stageConfigurator.elements[Tunnel.elementName]!
        let elementsIntersection = intersects(obstacles, tunnels)
        
        // Validate properties
        XCTAssertEqual(obstacles.count, 1, "Stage should have 1 obstacle")
        XCTAssertEqual(obstacles.first!.locations.count, 36, "Obstacle should have 36 obstacle locations")
        XCTAssertEqual(tunnels.count, 0, "Stage should have 0 tunnels")
        XCTAssertFalse(duplicates(obstacles.first!.locations), "There should not be two obstcales in the same location")
        XCTAssertEqual(elementsIntersection, [], "Obstacles and tunnels should not intersect")
        
    }

}
