//
//  SnakeTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/15/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import XCTest

class SnakeTests: XCTestCase, SnakeDelegate {

    
    weak var willMoveSnakeExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProperties() {
        let snake = Snake()
        
        XCTAssertTrue(snake.location? == nil, "Location is nil until the Sanke is added to a stage")
        XCTAssertTrue(snake.direction.rawValue >= 0, "Direction property should have a random value")
        XCTAssertNil(snake.delegate, "Snake has a delegate property")
        XCTAssertEqual(snake.speed, 0.5, "Snake's default speed is 0.5. It will move every 0.5 secs")
    }
    func testDelegateMoveSnake() {
        
        willMoveSnakeExpectation = self.expectationWithDescription("willMoveSnakeExpectation")
        
        let snake = SnakeMock()
        snake.delegate = self
        
        self.waitForExpectationsWithTimeout(2, handler: {
            (error) in
            XCTAssertEqual(snake.location!, StageLocation(x: 0, y: 0), "Location should be updated")
        })
    }
    
    func testKillSnake() {
        
        let snake = Snake()
        let timer = snake.moveTimer
        
        snake.kill()
        
        XCTAssertFalse(timer.valid, "Move timer should no longer be valid")
        XCTAssertNil(snake.moveTimer, "Reference to the timer should be released")
    }
    
    func testDidEatApple() {
        let snake = Snake()
        let originalSpeed = snake.speed
        snake.didEatApple()
        
        XCTAssertTrue(snake.speed < originalSpeed, "Snake should go faster")
    }
    
    // MARK: SnakeDelegate methods
    func moveSnake(snake: Snake) -> StageLocation? {
        snake.moveTimer.invalidate()
        willMoveSnakeExpectation?.fulfill()
        return StageLocation(x: 0, y: 0)
    }
    
}
