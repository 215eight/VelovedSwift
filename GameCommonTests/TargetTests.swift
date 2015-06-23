//
//  TagrgetTests.swift
//  GameSwift
//
//  Created by eandrade21 on 3/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class TargetTests: XCTestCase, StageElementDelegate {

    weak var didChangeLocationExpectation: XCTestExpectation?
    weak var wasSecuredExpectation: XCTestExpectation?
    
    func testProperties() {
        
        let targetLocations = [StageLocation(x: 1, y: 1)]
        let target = Target(locations: targetLocations, value: 10)
        let invalidTarget = Target(locations: targetLocations, value: -10)
        
        XCTAssertTrue(target.locations == targetLocations, "Target is at location x:1 y: 1")
        XCTAssertEqual(target.value, 10, "Target is 5 pionts")
        XCTAssertNil(target.delegate, "Target has a delegate property")
        XCTAssertEqual(invalidTarget.value, DefaultTargetValue, "Target value must be positive")
        XCTAssertEqual(invalidTarget.locations, targetLocations, "Locations is initialized even if value is negative")
        XCTAssertEqual(Target.elementName, "Target", "Target class name")
        XCTAssertNil(target.timer, "Timer should be nil at initialization")
    }
    
    func testDelegateRandomLocations() {
        
        let originalLocation = [StageLocation(x: 1, y: 1)]
        let updatedLocation = [StageLocation(x:2, y:2)]
        
        let target = Target(locations: originalLocation, value: 10)
        target.delegate = self
        
        target.updateLocation()
        
        XCTAssertNotEqual(target.locations, originalLocation, "Target locations should be different from initialization")
        XCTAssertEqual(target.locations, updatedLocation, "Target update locations should be x:2 y:2")
    }
    
    func testDelegateElementLocationDidChange() {
        
        didChangeLocationExpectation = self.expectationWithDescription("Did Change Location Expectation")
        
        let location = [StageLocation(x: 0, y: 0)]
        let target = Target(locations: location, value: 10)
        target.delegate = self
        
        target.updateLocation()
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testTargetWasSecured() {
        
        let originLocation = [StageLocation(x: 10, y: 10)]
        let updateLocation = [StageLocation(x: 2, y: 2)]
        
        let target = TargetMock(locations: originLocation, value: 10)
        target.delegate = self
        let timerInterval = target.timerInterval
        
        target.wasSecured()
        
        XCTAssertNotEqual(target.locations, originLocation, "Target locations should be different from initialization")
        XCTAssertEqual(target.locations, updateLocation, "Target locaitons should have been updated")
        XCTAssertTrue(target.timerInterval < timerInterval, "Target timer interval should be less than from initialization")
    }
    
    func testDestroyTarget() {
        
        let target = Target()
        target.destroy()
        
        XCTAssertNil(target.timer, "Timer should now be nil")
        XCTAssertNil(target.timer, "Reference to the timer should be released")
    }
    
    // MARK: StageElementDelegate methods
    func randomLocations(positions: Int) -> [StageLocation] {
        return [StageLocation(x: 2, y: 2)]
    }
    
    func randomLocations(positions: Int, direction: Direction) -> [StageLocation] {
        return randomLocations(positions)
    }
    
    func destinationLocation(location: StageLocation, direction: Direction) -> StageLocation {
        return StageLocation.zeroLocation()
    }
    
    func elementLocationDidChange(element: StageElement) {
        didChangeLocationExpectation?.fulfill()
        wasSecuredExpectation?.fulfill()
    }

    func broadcastElementDidChangeDirectionEvent(element: StageElementDirectable) {

    }

    func broadcastElementDidMoveEvent(element: StageElement) {
        
    }

}
