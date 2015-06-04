//
//  PlayerControllerTests.swift
//  GameSwift
//
//  Created by eandrade21 on 4/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class PlayerControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanRegisterPlayers() {
        let bindings = KeyboardControlBindings()
        let playerContoller = PlayerController(bindings: bindings)
        
        var registered: Bool
        let player1 = PlayerMock()
        registered = playerContoller.registerPlayer(player1)
        XCTAssertTrue(registered, "Player was registered. Two controllers left")
        
        let player2 = PlayerMock()
        registered = playerContoller.registerPlayer(player2)
        XCTAssertTrue(registered, "Sanke was registered. One controller left")
        
        let player3 = PlayerMock()
        registered = playerContoller.registerPlayer(player3)
        XCTAssertTrue(registered, "Player was registered. No controllers left thus no more players can be registered")
        
        let player4 = PlayerMock()
        registered = playerContoller.registerPlayer(player4)
        XCTAssertFalse(registered, "Since no controllers were left, player was not registered")
    }
    
    func testProcessKeyInput() {

        let bindings = KeyboardControlBindings()
        let playerController = PlayerController(bindings: bindings)
        playerController.isProcessingKeyInput = true
        
        let player1 = PlayerMock(locations: [StageLocation.zeroLocation()], direction: .Right)
        playerController.registerPlayer(player1)
        
        playerController.processKeyInput("d", direction: .Up)

        // d was previously transformed from Right to Up by view transform
        XCTAssertTrue(player1.direction == .Up, "Player1 should go Up after d was pressed")
    }

}
