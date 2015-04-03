//
//  SnakeTests.swift
//  SnakeSwift
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
        XCTAssertNil(snake.moveTimer, "Snake timer should not be active at initialization")
        XCTAssertEqual(snake.head, locations[0], "The head is the first location")
        XCTAssertEqual(snake.body, Array(locations[1...4]), "The body are all locations except the first")
        
        snake.kill()
    }
    
    func testMove() {
        
        let originLocations = [ StageLocation(x: 0, y: 1),
            StageLocation(x: 0, y: 2),
            StageLocation(x: 0, y: 3),
            StageLocation(x: 0, y: 4),
            StageLocation(x: 0, y: 5)]
        
        let snake = Snake(locations: originLocations, direction: .Up)
        snake.delegate = self
        
        snake.move()
        
        XCTAssertEqual(snake.locations, targetRandomLocations, "Snake locations must be updated")
        
        snake.kill()
        
    }
    
    func testDelegateElementLocationDidChange() {
        
        elementLocationDidChangeExpectation = self.expectationWithDescription("Element Location Did Change Expectation")
        
        let snake = SnakeMock()
        snake.delegate = self
        
        snake.move()
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
        
        snake.kill()
    }
    
    func testDidEatApple() {
        
        let snake = SnakeMock()
        snake.delegate = self
        let initialSpeed = snake.speed
        
        snake.didEatApple()
        
        XCTAssertTrue(snake.speed < initialSpeed, "Snake should move faster after eating an apple")
        XCTAssertNotNil(snake.moveTimer, "Snake move timer should be scheduled")
        
        snake.kill()
    }
    
    func testKillSnake() {
        
        let snake = Snake(locations: [StageLocation.zeroLocation()], direction: .Down)
        
        snake.kill()
        
        XCTAssertNil(snake.moveTimer, "Reference to the timer should be released")
    }
    
    // MARK: StageElementDelegate methods
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
