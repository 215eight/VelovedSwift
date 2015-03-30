//
//  StageTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class StageTests: XCTestCase, StageDelegate {
    
    var level1Config: StageConfigurator!
    var stage: Stage!

    weak var elementLocationDidChangeExpectation: XCTestExpectation?
    
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
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        // Validate properties
        XCTAssertEqual(stage.elements[Obstacle.className()]!, level1Config.elements[Obstacle.className()]!, "Stage elements should be the same as its configurator")
        XCTAssertEqual(stage.elements[Tunnel.className()]!, level1Config.elements[Tunnel.className()]!, "Stage elements should be the same as its configurator")
        XCTAssertNil(stage.elements[Snake.className()], "Stage should have no snakes")
        XCTAssertNil(stage.elements[Apple.className()], "Stage should have no apples")
    }
    
    func testDelegateRandomLocations() {
        level1Config = StageConfiguratorLevel1(size: StageSize(width: 3, height: 3))
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        let locations = stage.randomLocations(1)
        // A free location is not occupied by a loop hole or obstacle
        XCTAssertEqual(locations,[StageLocation(x: 1, y: 1)], "Gives a random free location")
        let obstacleLocations = stage.elements[Obstacle.className()]!.map( {$0.locations} )
        XCTAssertFalse(intersects(locations, obstacleLocations), "Locations should not intersect with obstacles")
    }
    
    func testCanAddApples() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        XCTAssertNil(stage.elements[Apple.className()], "Stage should not have apples")
        
        var location = stage.randomLocations(1)
        let apple = Apple(locations: location, value: 10)
        location = stage.randomLocations(1)
        let apple2 = Apple(locations: location, value: 5)
        
        stage.addElement(apple)
        XCTAssertEqual(stage.elements[Apple.className()]!, [apple], "Stage should have one apple")
        
        stage.addElement(apple2)
        XCTAssertEqual(stage.elements[Apple.className()]!, [apple, apple2], "Stage should have two apples")
        
        apple2.destroy()
        apple.destroy()
    }
    
    func testDelegateRandomLocationsWithDirection() {
        
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        let obstacleLocations = stage.elements[Obstacle.className()]!.map( {$0.locations} )
        let locations = stage.randomLocations(5, direction: Direction.Down)
        
        XCTAssertEqual(locations.count, 5, "Locations should contain 5 locations")
        XCTAssertFalse(duplicates(locations), "All locations should be different")
        XCTAssertFalse(intersects(locations, obstacleLocations), "Locations should not intersect with obstacles")
    }
    
    func testCanAddSnakes() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        XCTAssertNil(stage.elements[Snake.className()], "Stage should not have snakes")
        
        var locations = stage.randomLocations(5, direction: Direction.Up)
        let snake = Snake(locations: locations, direction: Direction.Up)
        
        stage.addElement(snake)
        XCTAssertEqual(stage.elements[Snake.className()]!, [snake], "Stage should have one snake")
        
        snake.kill()
        
//        TODO: Add a check to add element to not add elements already added
//        stage.addElement(snake)
//        XCTAssertEqual(stage.elements[Snake.className()]!, [snake], "Stage should still have one snake since it was previously added")
    
    }
    
    func testUpdateAppleLocation() {
        
        elementLocationDidChangeExpectation = self.expectationWithDescription("Element Location Did Change Expectations")
        
        stage = Stage.sharedStage
        stage.configurator = level1Config
        stage.delegate = self
        
        var locations = stage.randomLocations(1)
        let apple = AppleMock(locations: locations, value: 5)
        apple.delegate = stage
        stage.addElement(apple)
        apple.updateLocation()
        
        XCTAssertNotEqual(apple.locations, locations, "Apple location should have changed")
        XCTAssertEqual(stage.elements[AppleMock.className()]!.count, 1, "Apple count should remain the same")
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
        
        apple.destroy()
    }

    func testMoveSnakeWithoutTunnels() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        stage.delegate = self
        
        var snakeLocations = stage.randomLocations(5, direction: .Up)
        let snake = SnakeMock(locations: snakeLocations, direction: .Up)
        snake.delegate = stage
        stage.addElement(snake)
        
        snakeLocations = snakeLocations.map() { $0.destinationLocation(.Up) }
        
        snake.move()
        XCTAssertEqual(snake.locations, snakeLocations, "Snake should move one position up")
        
        
        snake.kill()
    }
    
    // TODO: testMoveSnakeWithTunnels
    
    
    func testDoesElementExist() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        let snakeLocations = stage.randomLocations(5, direction: .Down)
        let snake = SnakeMock(locations: snakeLocations, direction: .Down)
        
        let appleLocations = stage.randomLocations(1)
        let apple = AppleMock(locations: appleLocations, value: 10)
        
        let notAddedSnake = SnakeMock()
        let notAddedApple = AppleMock()
        
        stage.addElement(snake)
        stage.addElement(apple)
        
        let addedSnake = stage.doesElementExist(snake)
        let addedApple = stage.doesElementExist(apple)
        
        XCTAssertEqual(snake, addedSnake!, "Snake does exist on stage")
        XCTAssertEqual(apple, addedApple!, "Apple does exist on stage")
        XCTAssertNil(stage.doesElementExist(notAddedSnake), "Snake does not exist on stage")
        XCTAssertNil(stage.doesElementExist(notAddedApple), "Apple does not exist on stage")
        
        notAddedApple.destroy()
        notAddedSnake.kill()
        apple.destroy()
        snake.kill()
    }
    
    func testDidSnakeCrash() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        let snake = SnakeMock()
        stage.addElement(snake)
        
        XCTAssertTrue(stage.didSnakeCrash(snake), "Snake is on an obstacle location thus it should crash")
        
        snake.locations = [StageLocation(x: 1, y: 1)]
        XCTAssertFalse(stage.didSnakeCrash(snake), "Snake is not on an obstacle location thus it should not crash")
        
        snake.kill()
    }

    func testDidSnakeEatAnApple() {
        
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        var snakeLocations = [
            StageLocation(x:1, y:1),
            StageLocation(x:1, y:2)
            ]
        let snake = Snake(locations: snakeLocations, direction: .Up)
        stage.addElement(snake)
       
        let apple = Apple(locations: [StageLocation(x: 1, y: 1)], value: 10)
        stage.addElement(apple)
    
        let secondApple = Apple(locations: [StageLocation(x: 8, y: 8)], value: 5)
        stage.addElement(secondApple)
        
        var eatenApple = stage.didSnakeEatAnApple(snake)
        XCTAssertEqual(eatenApple!, apple, "Snake did eat an Apple")
        
        snakeLocations = [
            StageLocation(x:10, y:15),
            StageLocation(x:10, y:16)
        ]
        snake.locations = snakeLocations
        eatenApple = stage.didSnakeEatAnApple(snake)
        XCTAssertNil(eatenApple, "Snake did not eat an Apple")
        
        secondApple.destroy()
        apple.destroy()
        snake.kill()
    }
    
    func testDidSnakeEatItself() {
        
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        var snakeLocations = [ StageLocation(x: 10, y: 15),
            StageLocation(x: 10, y: 16),
            StageLocation(x: 9, y: 16),
            StageLocation(x: 9, y: 15),
            StageLocation(x: 10, y: 15),
            StageLocation(x: 11, y: 15)]
        
        var snake = Snake(locations: snakeLocations, direction: Direction.Up)
        XCTAssertTrue(stage.didSnakeEatItself(snake), "Yes, it did :(")
        
        snakeLocations = stage.randomLocations(5, direction: .Down)
        snake = Snake(locations: snakeLocations, direction: .Down)
        XCTAssertFalse(stage.didSnakeEatItself(snake), "No, it didn't :)")
    }
    
    // StageDelegate methods
    func elementLocationDidChange(element: StageElement, inStage stage: Stage) {
        elementLocationDidChangeExpectation?.fulfill()
    }
    
    
}