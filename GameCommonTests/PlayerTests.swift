//
//  PlayerTests.swift
//  GameSwift
//
//  Created by eandrade21 on 3/15/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

private let targetRandomLocations = [StageLocation(x: 0, y: 0),
    StageLocation(x: 0, y: 1),
    StageLocation(x: 0, y: 2),
    StageLocation(x: 0, y: 3),
    StageLocation(x: 0, y: 4)]

class PlayerTests: XCTestCase, StageElementDelegate {

    
    var locations: [StageLocation]!
    weak var elementLocationDidChangeExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        locations = [StageLocation(x: 10, y: 10),
            StageLocation(x: 10, y: 11),
            StageLocation(x: 10, y: 12),
            StageLocation(x: 10, y: 13),
            StageLocation(x: 10, y: 14)]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        locations = nil
        super.tearDown()
    }

    func testProperties() {
        
        let player = Player(locations: locations, direction: Direction.Up)
        
        XCTAssertEqual(player.locations, locations, "Locations should match init value")
        XCTAssertTrue(player.direction == Direction.Up, "Direction should match init value")
        XCTAssertNil(player.delegate, "player has a delegate property")
        XCTAssertEqual(player.speed, NSEC_PER_SEC / 2, "Player's default speed is 0.5. It will move every 0.5 secs")
        XCTAssertNil(player.moveTimer, "Player timer should not be active at initialization")
        XCTAssertEqual(player.head, locations[0], "The head is the first location")
        XCTAssertEqual(player.body, Array(locations[1...4]), "The body are all locations except the first")
        XCTAssertEqual(player.type, PlayerType.Solid, "Default type is solid")
        
        player.kill()
    }
    
    func testMove() {
        
        let originLocations = [ StageLocation(x: 0, y: 1),
            StageLocation(x: 0, y: 2),
            StageLocation(x: 0, y: 3),
            StageLocation(x: 0, y: 4),
            StageLocation(x: 0, y: 5)]
        
        let player = Player(locations: originLocations, direction: .Up)
        player.delegate = self
        
        player.move()
        
        XCTAssertEqual(player.locations, targetRandomLocations, "Player locations must be updated")
        
        player.kill()
        
    }
    
    func testDelegateElementLocationDidChange() {
        
        elementLocationDidChangeExpectation = self.expectationWithDescription("Element Location Did Change Expectation")
        
        let player = PlayerMock()
        player.delegate = self
        
        player.move()
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
        
        player.kill()
    }
    
    func testDidSecureTarget() {
        
        let player = PlayerMock()
        player.delegate = self
        let initialSpeed = player.speed
        
        player.didSecureTarget()
        
        XCTAssertTrue(player.speed < initialSpeed, "Player should move faster after eating a target")
        XCTAssertNotNil(player.moveTimer, "Player move timer should be scheduled")
        
        player.kill()
    }
    
    func testKillPlayer() {
        
        let player = Player(locations: [StageLocation.zeroLocation()], direction: .Down)
        
        player.kill()
        
        XCTAssertNil(player.moveTimer, "Reference to the timer should be released")
    }
}

extension PlayerTests: StageElementDelegate {

    func broadcastElementDidMoveEvent(element: StageElement) {
        
    }

    func randomLocations(positions: Int) -> [StageLocation] {
        return [StageLocation(x: 0, y: 0)]
    }

    func randomLocations(positions: Int, direction: Direction) -> [StageLocation] {
        return targetRandomLocations
    }

    func destinationLocation(location: StageLocation, direction: Direction) -> StageLocation {
        return targetRandomLocations.first!
    }

    func elementLocationDidChange(element: StageElement) {
        elementLocationDidChangeExpectation?.fulfill()
    }
}