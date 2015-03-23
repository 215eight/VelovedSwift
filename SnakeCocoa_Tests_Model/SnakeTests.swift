//
//  SnakeTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/15/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import XCTest

private let targetRandomLocations = [StageLocation(x: 0, y: 0),
    StageLocation(x: 0, y: 1),
    StageLocation(x: 0, y: 2),
    StageLocation(x: 0, y: 3),
    StageLocation(x: 0, y: 4)]

class SnakeTests: XCTestCase, StageElementDelegate {

    
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
        
        let snake = Snake(locations: locations, direction: Direction.Up)
        
        XCTAssertEqual(snake.locations, locations, "Locations should match init value")
        XCTAssertTrue(snake.direction == Direction.Up, "Direction should match init value")
        XCTAssertNil(snake.delegate, "Snake has a delegate property")
        XCTAssertEqual(snake.speed, 0.5, "Snake's default speed is 0.5. It will move every 0.5 secs")
        XCTAssertNotNil(snake.moveTimer, "Snake timer should be scheduled")
    }
    
    func testDelegateRandomLocations() {
        
        let snake = SnakeMock()
        snake.delegate = self
        
        snake.move()
        
        XCTAssertEqual(snake.locations, targetRandomLocations, "Snake locations must be updated")
        
    }
    
    func testDelegateElementLocationDidChange() {
        
        elementLocationDidChangeExpectation = self.expectationWithDescription("Element Location Did Change Expectation")
        
        let snake = SnakeMock()
        snake.delegate = self
        
        snake.move()
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testDidEatApple() {
        
        let snake = SnakeMock()
        snake.delegate = self
        let initialSpeed = snake.speed
        
        snake.didEatApple()
        
        XCTAssertTrue(snake.speed < initialSpeed, "Snake should move faster after eating an apple")
        XCTAssertNotNil(snake.moveTimer, "Snake move timer should be scheduled")
        XCTAssertTrue(snake.moveTimer.timeInterval < initialSpeed, "Snake should move fater after eating an apple")
    }
    
    func testKillSnake() {
        
        let snake = Snake()
        let timer = snake.moveTimer
        
        snake.kill()
        
        XCTAssertFalse(timer.valid, "Move timer should no longer be valid")
        XCTAssertNil(snake.moveTimer, "Reference to the timer should be released")
    }
    
    // MARK: StageElementDelegate methods
    func randomLocations(positions: Int) -> [StageLocation] {
        return [StageLocation(x: 0, y: 0)]
    }
    
    func randomLocations(positions: Int, direction: Direction?) -> [StageLocation] {
        return targetRandomLocations
    }
    
    func elementLocationDidChange(element: StageElement) {
        elementLocationDidChangeExpectation?.fulfill()
    }
}
