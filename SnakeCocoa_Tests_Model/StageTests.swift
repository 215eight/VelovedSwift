//
//  StageTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class StageTests: XCTestCase {
    
    var level1Config: StageConfigurator!
    var stage: Stage!
    
    override func setUp() {
        super.setUp()
        level1Config = StageConfiguratorLevel1(size: StageSize(width: 10, height: 10))
    }
    
    override func tearDown() {
        level1Config = nil
        stage = nil
        super.tearDown()
    }
    
    func testProperties() {
        stage = Stage(configurator: level1Config)
        // Validate properties
        XCTAssertEqual(stage.elements[Obstacle.className()]!, level1Config.elements[Obstacle.className()]!, "Stage elements should be the same as its configurator")
        XCTAssertEqual(stage.elements[LoopHole.className()]!, level1Config.elements[LoopHole.className()]!, "Stage elements should be the same as its configurator")
        XCTAssertNil(stage.elements[Snake.className()], "Stage should have no snakes")
        XCTAssertNil(stage.elements[Apple.className()], "Stage should have no apples")
    }
    
    func testRandomLocation() {
        level1Config = StageConfiguratorLevel1(size: StageSize(width: 3, height: 3))
        stage = Stage(configurator: level1Config)
        // A free location is not occupied by a loop hole or obstacle
        XCTAssertEqual(stage.randomLocation(), StageLocation(x: 1, y: 1), "Gives a random free location")
    }
    
    func testCanAddApples() {
        stage = Stage(configurator: level1Config)
        
        let apple = Apple()
        let location = stage.addElement(apple)
        XCTAssertTrue(stage.contains(location), "Positions object in grid")
        XCTAssertEqual(apple.location!, location, "Apple's location should be updated")
    }
    
    func testUpdateAppleLocation() {
        stage = Stage(configurator: level1Config)
        
        let apple = Apple()
        let originalLocation = stage.addElement(apple)
        let newLocation = stage.updateAppleLocation(apple)
        
        XCTAssertNotEqual(newLocation, originalLocation, "Apple location should have changed")
        XCTAssertEqual(stage.elements[Apple.className()]!.count, 1, "Apple count should remain the same")
    }
    
    func testCanAddSnakes() {
        
        stage = Stage(configurator: level1Config)
        
        let snake = Snake()
        let location = stage.addElement(snake)
        XCTAssertTrue(stage.contains(location), "Poistions object in grid")
        XCTAssertEqual(snake.location!, location, "Snake's location should be updated")
    }
    
    func testMoveSnakeWithoutLoopHoles() {
        stage = Stage(configurator: level1Config)
        
        let snake = Snake()
        stage.addElement(snake)
        let originLocation = StageLocation(x: 1, y: 1)
        
        let destinationLocationUp = StageLocation(x: 1, y: 0)
        let destinationLocationDown = StageLocation(x: 1, y: 2)
        let destinationLocationLeft = StageLocation(x: 0, y: 1)
        let destinationLocationRight = StageLocation(x:2, y: 1)
        
        snake.location = originLocation
        snake.resetDirectionState()
        snake.direction = .Up
        XCTAssertEqual(stage.moveSnake(snake), destinationLocationUp, "Snake should move one position up")
        
        snake.location = originLocation
        snake.resetDirectionState()
        snake.direction = .Left
        XCTAssertEqual(stage.moveSnake(snake), destinationLocationLeft, "Snake should move one position left")
        
        snake.location = originLocation
        snake.resetDirectionState()
        snake.direction = .Down
        XCTAssertEqual(stage.moveSnake(snake), destinationLocationDown, "Snake should move one position down")
        
        snake.location = originLocation
        snake.resetDirectionState()
        snake.direction = .Right
        XCTAssertEqual(stage.moveSnake(snake), destinationLocationRight, "Snake should move one position right")
    }
    
    // TODO: testMoveSnakeWithLoopHoles
    
    
}