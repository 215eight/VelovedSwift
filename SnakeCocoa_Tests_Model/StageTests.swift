//
//  StageTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class StageTests: XCTestCase {
    
    var level1Config: StageConfigurator!
    var stage: Stage!
    
    override func setUp() {
        super.setUp()
        level1Config = StageConfiguratorLevel1(size: StageSize(width: 10, height: 10))
    }
    
    func testProperties() {
        stage = Stage(configurator: level1Config)
        // Validate properties
        XCTAssertEqual(stage.obstacles, level1Config.obstacles, "Stage obstacles should be the same as its configurator")
        XCTAssertEqual(stage.loopHoles, level1Config.loopHoles, "Stage loopHoles should be the same as its configurator")
        XCTAssertEqual(stage.snakes, [Snake](), "Stage should have no snakes")
        XCTAssertEqual(stage.apples, [Apple](), "Stage should have no apples")
    }
    
    func testRandomLocation() {
        level1Config = StageConfiguratorLevel1(size: StageSize(width: 3, height: 3))
        stage = Stage(configurator: level1Config)
        // A free location is not occupied by a loop hole or obstacle
        XCTAssertEqual(stage.randomLocation(), StageLocation(x: 1, y: 1), "Gives a random free location")
    }
    
}