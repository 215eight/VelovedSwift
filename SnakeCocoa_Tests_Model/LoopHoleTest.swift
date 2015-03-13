//
//  LoopHoleTest.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class LoopHoleTest: XCTestCase {

    // MARK: Properties
    var location : StageLocation!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        location = StageLocation(x:10, y:10)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProperties() {
        
        // Create a loop hole
        let loopHole = LoopHole(location: location)
        
        // Validate properties
        XCTAssertTrue(loopHole.location == location, "Property incorrectly initialized")
        XCTAssertTrue(loopHole.targets.isEmpty, "Property incorrectly initialized")
    }
    
    func testDestinationLocationWithEmptyTargets() {
        
        // Create a loop hole and destination location
        let loopHole = LoopHole(location: location)
        let destLocationUp = StageLocation(x:10, y:9)
        let destLocationDown = StageLocation(x:10, y:11)
        let destLocationLeft = StageLocation(x:9, y:10)
        let destLocationRight = StageLocation(x:11, y:10)
        
        // Validate
        XCTAssertTrue(loopHole.targets.isEmpty, "Target are not empty")
        XCTAssertTrue(loopHole.destinationLocation(Direction.Up) == destLocationUp, "Destination location is not correct")
        XCTAssertTrue(loopHole.destinationLocation(Direction.Down) == destLocationDown, "Destination location is not correct")
        XCTAssertTrue(loopHole.destinationLocation(Direction.Left) == destLocationLeft, "Destination location is not correct")
        XCTAssertTrue(loopHole.destinationLocation(Direction.Right) == destLocationRight, "Destination location is not correct")
    }
    
    func testAddingTarget() {
        
        // Create loop hole and its targets
        var loopHole = LoopHole(location: location)
        let targetLocation = StageLocation(x: 20, y: 20)
        let targetLoopHole = LoopHole(location: targetLocation)
        let targetLocation2 = StageLocation(x:30, y:30)
        let targetObstacle = Obstacle(location: targetLocation2)
        
        // Add target
        loopHole.addTarget(targetLoopHole, forDirection: Direction.Up)
        loopHole.addTarget(targetObstacle, forDirection: Direction.Down)
        
        // Validate added targets
        XCTAssertFalse(loopHole.targets.isEmpty, "Targets not added")
        XCTAssertEqual(loopHole.targets[Direction.Up]!.location, targetLocation, "Target incorrectly added")
        XCTAssertEqual(loopHole.targets[Direction.Down]!.location, targetLocation2, "Target incorrectly added")
    }
    
    func testDestinationLocationWithTargets() {
        
        // Create loop hole and its targets
        var loopHole = LoopHole(location: location)
        let targetLocationUp = StageLocation(x: 20, y: 20)
        let targetLoopHole = LoopHole(location: targetLocationUp)
        let targetLocationDown = StageLocation(x:30, y:30)
        let targetObstacle = Obstacle(location: targetLocationDown)
        let targetLocationRight = StageLocation(x: 11, y: 10)
        let targetLocationLeft = StageLocation(x: 9, y:10)
        
        // Add targets
        loopHole.addTarget(targetLoopHole, forDirection: Direction.Up)
        loopHole.addTarget(targetObstacle, forDirection: Direction.Down)
        
        // Validate target directions
        XCTAssertEqual(loopHole.destinationLocation(Direction.Up), targetLocationUp, "Incorrect target direction")
        XCTAssertEqual(loopHole.destinationLocation(Direction.Down), targetLocationDown, "Incorrect target direction")
        XCTAssertEqual(loopHole.destinationLocation(Direction.Left), targetLocationLeft, "Incorrect target direction")
        XCTAssertEqual(loopHole.destinationLocation(Direction.Right), targetLocationRight, "Incorrect target direction")
        
    }
}
