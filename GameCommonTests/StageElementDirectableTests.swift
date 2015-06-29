//
//  StageElementDirectable.swift
//  VelovedGame
//
//  Created by eandrade21 on 3/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class StageElementDirectableTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProperties(){
        
        let loc1 = StageLocation(x: 0, y: 0)
        let loc2 = StageLocation(x: 0, y: 1)
        let loc3 = StageLocation(x: 0, y: 2)
        let loc4 = StageLocation(x: 0, y: 3)
        let loc5 = StageLocation(x: 0, y: 4)
        let locations = [loc1, loc2, loc3, loc4, loc5]
        
        let element = StageElementDirectable(locations: locations, direction: Direction.Up)
        
        XCTAssertEqual(element.locations, locations, "Element should inherit the locations property")
        XCTAssertEqual(element.direction, Direction.Up, "Element has a direction property")
        
    }
    
    func testChangeDirection() {
        
        let locations = [StageLocation(x: 0, y: 0)]
        let element = StageElementDirectable(locations: locations, direction: Direction.Down)
        
        element.direction = Direction.Down
        XCTAssertEqual(element.direction, Direction.Down, "Setting direction to the same value should remain equal")
        
        element.direction = Direction.Up
        XCTAssertEqual(element.direction, Direction.Down, "Setting opposite direction in the same axis is not valid, direction should remain")
        
        element.direction = Direction.Right
        XCTAssertEqual(element.direction, Direction.Right, "Change of direction in different axis is allowed")
        
        element.direction = Direction.Up
        XCTAssertEqual(element.direction, Direction.Right, "After a direction change, only changes in the same axis are allowed until the direction state is reset")
        
        element.resetDirectionState()
        element.direction = Direction.Up
        XCTAssertEqual(element.direction, Direction.Up, "Chage of direction in different axis is now allowed because the direction state was reset")
    }
}
