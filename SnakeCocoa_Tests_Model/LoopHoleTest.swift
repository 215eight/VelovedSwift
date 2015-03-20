//
//  LoopHoleTest.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class LoopHoleTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProperties() {
        
        // Create a loop hole
        let locations = [StageLocation(x: 0, y: 0)]
        let loopHole = LoopHole(locations: locations)
        
        // Validate properties
        XCTAssertTrue(loopHole.locations == locations, "Property incorrectly initialized")
        XCTAssertTrue(loopHole.targets.isEmpty, "Property incorrectly initialized")
    }
    
    func testDestinationLocationWithEmptyTargets() {
        
        // Create a loop hole and destination location
        let locations = [StageLocation(x: 10, y: 10)]
        let loopHole = LoopHole(locations: locations)
        let destLocationUp = StageLocation(x:10, y:9)
        let destLocationDown = StageLocation(x:10, y:11)
        let destLocationLeft = StageLocation(x:9, y:10)
        let destLocationRight = StageLocation(x:11, y:10)
        
        // Validate
        XCTAssertTrue(loopHole.targets.isEmpty, "Targets must be empty")
        XCTAssertTrue(loopHole.destinationLocation(Direction.Up) == destLocationUp, "Destination location is not correct")
        XCTAssertTrue(loopHole.destinationLocation(Direction.Down) == destLocationDown, "Destination location is not correct")
        XCTAssertTrue(loopHole.destinationLocation(Direction.Left) == destLocationLeft, "Destination location is not correct")
        XCTAssertTrue(loopHole.destinationLocation(Direction.Right) == destLocationRight, "Destination location is not correct")
    }
    
    func testAddingTarget() {
        
        // Create loop hole and its targets
        var locations = [StageLocation(x: 0, y: 0)]
        var loopHole = LoopHole(locations: locations)
        let targetLocation = StageLocation(x: 20, y: 20)
        let targetLoopHole = LoopHole(locations: [targetLocation])
        let targetLocation2 = StageLocation(x:30, y:30)
        let targetObstacle = Obstacle(locations: [targetLocation2])
        
        // Add target
        loopHole.addTarget(targetLoopHole, forDirection: Direction.Up)
        loopHole.addTarget(targetObstacle, forDirection: Direction.Down)
        
        // Validate added targets
        XCTAssertFalse(loopHole.targets.isEmpty, "Targets must include added targets")
        XCTAssertEqual(loopHole.targets[Direction.Up]!.locations.first!, targetLocation, "Target location for the specified direction must match")
        XCTAssertEqual(loopHole.targets[Direction.Down]!.locations.first!, targetLocation2, "Target location for the specified direction must match")
    }
    
    func testDestinationLocationWithTargets() {
        
        // Create loop hole and its targets
        let locations = [StageLocation(x: 10, y: 10)]
        var loopHole = LoopHole(locations: locations)
        let targetLocationUp = StageLocation(x: 20, y: 20)
        let targetLoopHole = LoopHole(locations: [targetLocationUp])
        let targetLocationDown = StageLocation(x:30, y:30)
        let targetObstacle = Obstacle(locations: [targetLocationDown])
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
    
    func testInvalidInitialization() {
        let locations = [StageLocation(x: 0, y: 0), StageLocation(x: 0, y: 1)]
        //Throws assertion
        //let loopHole = LoopHole(locations: locations)
    }
    
    func testAddingInvalidTarget() {
        let loopHole = LoopHole(locations: [StageLocation(x: 0, y: 0)])
        
        let locations = [StageLocation(x: 0, y: 0), StageLocation(x: 0, y: 1)]
        let targetObstacle = Obstacle(locations: locations)
        //Throws assertion
        //loopHole.addTarget(targetObstacle, forDirection: Direction.Down)
    }
}
