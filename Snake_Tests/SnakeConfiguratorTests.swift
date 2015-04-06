//
//  SnakeConfigurator.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/5/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class SnakeConfiguratorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetSnake() {
        let stage = Stage.sharedStage
        stage.configurator = StageConfiguratorLevel1(size: StageSize(width: 10, height: 10))
        let typeGenerator = SnakeTypeGenerator()
        var snakeConfigurator = SnakeConfigurator(stage: stage, bodySize: 5, typeGenerator: typeGenerator)
        let snake = snakeConfigurator.getSnake()
        
        XCTAssertEqual(snake!.locations.count, 5, "Snake should have 5 body parts")
        XCTAssertTrue(snake?.direction != nil, "Snake should go in a direction")
        XCTAssertTrue(snake?.type == SnakeType.Solid, "Snake should have a type")
    }
    
    func testGetSnakeTypeProperty() {
        let stage = Stage.sharedStage
        stage.configurator = StageConfiguratorLevel1(size: StageSize(width: 10, height: 10))
        let typeGenerator = SnakeTypeGenerator()
        var snakeConfigurator = SnakeConfigurator(stage: stage, bodySize: 5, typeGenerator: typeGenerator)
        
        let snake1 = snakeConfigurator.getSnake()
        let snake2 = snakeConfigurator.getSnake()
        let snake3 = snakeConfigurator.getSnake()
        
        XCTAssertTrue(snake1?.type == SnakeType.Solid, "Snake type is solid")
        XCTAssertTrue(snake2?.type == SnakeType.Squared, "Snake type is squared")
        XCTAssertTrue(snake3 == nil, "If the type generator has no more types, then there can't be a snake")
        
    }
}