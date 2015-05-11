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
        var snakeConfigurator = SnakeConfigurator(stage: stage)

    }
    
    func testGetSnakeTypeProperty() {
        let stage = Stage.sharedStage
        stage.configurator = StageConfiguratorLevel1(size: StageSize(width: 10, height: 10))
        let typeGenerator = SnakeTypeGenerator()
        var snakeConfigurator = SnakeConfigurator(stage: stage)
        
    }
}