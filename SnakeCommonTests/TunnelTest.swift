//
//  TunnelTest.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class TunnelTest: XCTestCase {

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
        let tunnel = Tunnel(locations: locations)
        
        // Validate properties
        XCTAssertTrue(tunnel.locations == locations, "Property incorrectly initialized")
        XCTAssertTrue(tunnel.targets.isEmpty, "Property incorrectly initialized")
    }
    
    func testDestinationLocationWithEmptyTargets() {
        
        // Create a loop hole and destination location
        let locations = [StageLocation(x: 10, y: 10)]
        let tunnel = Tunnel(locations: locations)
        let destLocationUp = StageLocation(x:10, y:9)
        let destLocationDown = StageLocation(x:10, y:11)
        let destLocationLeft = StageLocation(x:9, y:10)
        let destLocationRight = StageLocation(x:11, y:10)
        
        // Validate
        XCTAssertTrue(tunnel.targets.isEmpty, "Targets must be empty")
        XCTAssertTrue(tunnel.destinationLocation(Direction.Up) == destLocationUp, "Destination location is not correct")
        XCTAssertTrue(tunnel.destinationLocation(Direction.Down) == destLocationDown, "Destination location is not correct")
        XCTAssertTrue(tunnel.destinationLocation(Direction.Left) == destLocationLeft, "Destination location is not correct")
        XCTAssertTrue(tunnel.destinationLocation(Direction.Right) == destLocationRight, "Destination location is not correct")
    }
    
    func testAddingTarget() {
        
        // Create loop hole and its targets
        var locations = [StageLocation(x: 0, y: 0)]
        var tunnel = Tunnel(locations: locations)
        let targetLocation = StageLocation(x: 20, y: 20)
        let targetTunnel = Tunnel(locations: [targetLocation])
        let targetLocation2 = StageLocation(x:30, y:30)
        let targetObstacle = Obstacle(locations: [targetLocation2])
        
        // Add target
        tunnel.addTarget(targetTunnel, forDirection: Direction.Up)
        tunnel.addTarget(targetObstacle, forDirection: Direction.Down)
        
        // Validate added targets
        XCTAssertFalse(tunnel.targets.isEmpty, "Targets must include added targets")
        XCTAssertEqual(tunnel.targets[Direction.Up]!.locations.first!, targetLocation, "Target location for the specified direction must match")
        XCTAssertEqual(tunnel.targets[Direction.Down]!.locations.first!, targetLocation2, "Target location for the specified direction must match")
    }
    
    func testDestinationLocationWithTargets() {
        
        // Create loop hole and its targets
        let locations = [StageLocation(x: 10, y: 10)]
        var tunnel = Tunnel(locations: locations)
        let targetLocationUp = StageLocation(x: 20, y: 20)
        let targetTunnel = Tunnel(locations: [targetLocationUp])
        let targetLocationDown = StageLocation(x:30, y:30)
        let targetObstacle = Obstacle(locations: [targetLocationDown])
        let targetLocationRight = StageLocation(x: 11, y: 10)
        let targetLocationLeft = StageLocation(x: 9, y:10)
        
        // Add targets
        tunnel.addTarget(targetTunnel, forDirection: Direction.Up)
        tunnel.addTarget(targetObstacle, forDirection: Direction.Down)
        
        // Validate target directions
        XCTAssertEqual(tunnel.destinationLocation(Direction.Up), targetLocationUp, "Incorrect target direction")
        XCTAssertEqual(tunnel.destinationLocation(Direction.Down), targetLocationDown, "Incorrect target direction")
        XCTAssertEqual(tunnel.destinationLocation(Direction.Left), targetLocationLeft, "Incorrect target direction")
        XCTAssertEqual(tunnel.destinationLocation(Direction.Right), targetLocationRight, "Incorrect target direction")
        
    }
    
    func testInvalidInitialization() {
        let locations = [StageLocation(x: 0, y: 0), StageLocation(x: 0, y: 1)]
        //Throws assertion
        //let tunnel = Tunnel(locations: locations)
    }
    
    func testAddingInvalidTarget() {
        let tunnel = Tunnel(locations: [StageLocation(x: 0, y: 0)])
        
        let locations = [StageLocation(x: 0, y: 0), StageLocation(x: 0, y: 1)]
        let targetObstacle = Obstacle(locations: locations)
        //Throws assertion
        //tunnel.addTarget(targetObstacle, forDirection: Direction.Down)
    }
}
