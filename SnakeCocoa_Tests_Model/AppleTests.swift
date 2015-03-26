//
//  AppleTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class AppleTests: XCTestCase, StageElementDelegate {

    weak var didChangeLocationExpectation: XCTestExpectation?
    weak var wasEatenExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProperties() {
        
        let appleLocations = [StageLocation(x: 1, y: 1)]
        let apple = Apple(locations: appleLocations, value: 10)
        let invalidApple = Apple(locations: appleLocations, value: -10)
        
        XCTAssertTrue(apple.locations == appleLocations, "Apple is at location x:1 y: 1")
        XCTAssertEqual(apple.value, 10, "Apple is 5 pionts")
        XCTAssertNil(apple.delegate, "Apple has a delegate property")
        XCTAssertEqual(invalidApple.value, 0, "Apple value must be positive")
        XCTAssertEqual(invalidApple.locations, appleLocations, "Locations is initialized even if value is negative")
        XCTAssertEqual(Apple.className(), "Apple", "Apple class name")
    }
    
    func testDelegateRandomLocations() {
        
        let originalLocation = [StageLocation(x: 1, y: 1)]
        let updatedLocation = [StageLocation(x:2, y:2)]
        
        let apple = Apple(locations: originalLocation, value: 10)
        apple.delegate = self
        
        apple.updateLocation()
        
        XCTAssertNotEqual(apple.locations, originalLocation, "Apple locations should be different from initialization")
        XCTAssertEqual(apple.locations, updatedLocation, "Apple update locations should be x:2 y:2")
    }
    
    func testDelegateElementLocationDidChange() {
        
        didChangeLocationExpectation = self.expectationWithDescription("Did Change Location Expectation")
        
        let location = [StageLocation(x: 0, y: 0)]
        let apple = Apple(locations: location, value: 10)
        apple.delegate = self
        
        apple.updateLocation()
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testAppleWasEaten() {
        
        let originLocation = [StageLocation(x: 10, y: 10)]
        let updateLocation = [StageLocation(x: 2, y: 2)]
        
        let apple = AppleMock(locations: originLocation, value: 10)
        apple.delegate = self
        let timerInterval = apple.timerInterval
        
        apple.wasEaten()
        
        XCTAssertNotEqual(apple.locations, originLocation, "Apple locations should be different from initialization")
        XCTAssertEqual(apple.locations, updateLocation, "Apple locaitons should have been updated")
        XCTAssertTrue(apple.timerInterval < timerInterval, "Apple timer interval should be less than from initialization")
    }
    
    func testDestroyApple() {
        
        let apple = Apple()
        let timer = apple.timer
        apple.destroy()
        
        XCTAssertFalse(timer.valid, "Timer should no longer be valid")
        XCTAssertNil(apple.timer, "Reference to the timer should be released")
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
        wasEatenExpectation?.fulfill()
    }
}
