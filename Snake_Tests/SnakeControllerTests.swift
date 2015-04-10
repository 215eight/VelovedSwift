//
//  SnakeControllerTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class SnakeControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanRegisterSnakes() {
        let bindings = KeyboardControlBindings()
        let snakeContoller = SnakeController(bindings: bindings)
        
        var registered: Bool
        let snake1 = SnakeMock()
        registered = snakeContoller.registerSnake(snake1)
        XCTAssertTrue(registered, "Snake was registered. Two controllers left")
        
        let snake2 = SnakeMock()
        registered = snakeContoller.registerSnake(snake2)
        XCTAssertTrue(registered, "Sanke was registered. One controller left")
        
        let snake3 = SnakeMock()
        registered = snakeContoller.registerSnake(snake3)
        XCTAssertTrue(registered, "Snake was registered. No controllers left thus no more snakes can be registered")
        
        let snake4 = SnakeMock()
        registered = snakeContoller.registerSnake(snake4)
        XCTAssertFalse(registered, "Since no controllers were left, snake was not registered")
    }
    
    func testProcessKeyInput() {
        let bindings = KeyboardControlBindings()
        let snakeController = SnakeController(bindings: bindings)
        
        let snake1 = SnakeMock(locations: [StageLocation.zeroLocation()], direction: .Down)
        snakeController.registerSnake(snake1)
        
        snakeController.processKeyInput("d")
        
        XCTAssertTrue(snake1.direction == .Right, "Snake1 should go right after d was pressed")
    }

}
