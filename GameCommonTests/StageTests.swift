//
//  StageTests.swift
//  GameSwift
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class StageTests: XCTestCase {
    
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
        XCTAssertEqual(stage.elements[Obstacle.elementName]!, level1Config.elements[Obstacle.elementName]!, "Stage elements should be the same as its configurator")
        XCTAssertEqual(stage.elements[Tunnel.elementName]!, level1Config.elements[Tunnel.elementName]!, "Stage elements should be the same as its configurator")
        XCTAssertNil(stage.elements[Player.elementName], "Stage should have no players")
        XCTAssertNil(stage.elements[Target.elementName], "Stage should have no targets")
    }
    
    func testDelegateRandomLocations() {
        level1Config = StageConfiguratorLevel1(size: StageSize(width: 3, height: 3))
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        let locations = stage.randomLocations(1)
        // A free location is not occupied by a loop hole or obstacle
        XCTAssertEqual(locations,[StageLocation(x: 1, y: 1)], "Gives a random free location")
        let obstacleLocations = stage.elements[Obstacle.elementName]!.map( {$0.locations} )
        XCTAssertFalse(intersects(locations, obstacleLocations), "Locations should not intersect with obstacles")
    }
    
    func testCanAddTargets() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        XCTAssertNil(stage.elements[Target.elementName], "Stage should not have targets")
        
        var location = stage.randomLocations(1)
        let target = Target(locations: location, value: 10)
        location = stage.randomLocations(1)
        let target2 = Target(locations: location, value: 5)
        
        stage.addElement(target)
        XCTAssertEqual(stage.elements[Target.elementName]!, [target], "Stage should have one target")
        
        stage.addElement(target2)
        XCTAssertEqual(stage.elements[Target.elementName]!, [target, target2], "Stage should have two targets")
        
        target2.destroy()
        target.destroy()
    }
    
    func testDelegateRandomLocationsWithDirection() {
        
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        let obstacleLocations = stage.elements[Obstacle.elementName]!.map( {$0.locations} )
        let locations = stage.randomLocations(5, direction: Direction.Down)
        
        XCTAssertEqual(locations.count, 5, "Locations should contain 5 locations")
        XCTAssertFalse(duplicates(locations), "All locations should be different")
        XCTAssertFalse(intersects(locations, obstacleLocations), "Locations should not intersect with obstacles")
    }
    
    func testCanAddPlayers() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        XCTAssertNil(stage.elements[Player.elementName], "Stage should not have players")
        
        var locations = stage.randomLocations(5, direction: Direction.Up)
        let player = Player(locations: locations, direction: Direction.Up)
        
        stage.addElement(player)
        XCTAssertEqual(stage.elements[Player.elementName]!, [player], "Stage should have one player")
        
        player.deactivate()
        
//        TODO: Add a check to add element to not add elements already added
//        stage.addElement(player)
//        XCTAssertEqual(stage.elements[PlayergetClassName()]!, [player], "Stage should still have one player since it was previously added")
    
    }
    
    func testUpdateTargetLocation() {
        
        elementLocationDidChangeExpectation = self.expectationWithDescription("Element Location Did Change Expectations")
        
        stage = Stage.sharedStage
        stage.configurator = level1Config
        stage.delegate = self
        
        var locations = stage.randomLocations(1)
        let target = TargetMock(locations: locations, value: 5)
        target.delegate = stage
        stage.addElement(target)
        target.updateLocation()
        
        XCTAssertNotEqual(target.locations, locations, "target location should have changed")
        XCTAssertEqual(stage.elements[TargetMock.elementName]!.count, 1, "target count should remain the same")
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
        
        target.destroy()
    }

    func testMovePlayerWithoutTunnels() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        stage.delegate = self
        
        var playerLocations = stage.randomLocations(5, direction: .Up)
        let player = PlayerMock(locations: playerLocations, direction: .Up)
        player.delegate = stage
        stage.addElement(player)
        
        playerLocations = playerLocations.map() { $0.destinationLocation(.Up) }
        
        player.move()
        XCTAssertEqual(player.locations, playerLocations, "Player should move one position up")
        
        
        player.deactivate()
    }
    
    // TODO: testMovePlayerWithTunnels
    
    
    func testDoesElementExist() {
        stage = Stage.sharedStage
        
        let playerLocations = stage.randomLocations(5, direction: .Down)
        let player = PlayerMock(locations: playerLocations, direction: .Down)
        
        let targetLocations = stage.randomLocations(1)
        let target = TargetMock(locations: targetLocations, value: 10)
        
        let notAddedPlayer = PlayerMock()
        let notAddedTarget = TargetMock()
        
        stage.addElement(player)
        stage.addElement(target)
        
        XCTAssertTrue(stage.doesElementExist(player), "Player does exist on stage")
        XCTAssertTrue(stage.doesElementExist(target), "Target does exist on stage")
        XCTAssertFalse(stage.doesElementExist(notAddedPlayer), "Player does not exist on stage")
        XCTAssertFalse(stage.doesElementExist(notAddedTarget), "Target does not exist on stage")
        
        notAddedTarget.destroy()
        notAddedPlayer.deactivate()
        target.destroy()
        player.deactivate()
    }
    
    func testDidPlayerCrashWithAnObstacle() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        let player = PlayerMock()
        player.locations = [StageLocation.zeroLocation()]
        stage.addElement(player)
        
        XCTAssertTrue(stage.didPlayerCrashWithAnObstacle(player), "Player is on an obstacle location thus it should crash")
        
        player.locations = [StageLocation(x: 1, y: 1)]
        XCTAssertFalse(stage.didPlayerCrashWithAnObstacle(player), "Player is not on an obstacle location thus it should not crash")
        
        player.deactivate()
    }
    
    func testDidPlayerCrashWithOtherPlayer() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        let player = Player(locations: [StageLocation.zeroLocation()],
            direction: Direction.randomDirection())
        stage.addElement(player)
        
        XCTAssertFalse(stage.didPlayerCrashWithOtherPlayer(player), "There are no other players to crash in the stage")
        
        var player2Locations = [StageLocation(x: 2, y: 0),
                                StageLocation(x: 1, y: 0),
                                StageLocation(x:0, y:0)]
        let player2 = Player(locations: player2Locations, direction: Direction.randomDirection())
        stage.addElement(player2)
        XCTAssertTrue(stage.didPlayerCrashWithOtherPlayer(player), "The head of the player is touching the body of other player")
        
        player2.locations = [StageLocation(x: 1, y: 1),
                            StageLocation(x:2, y:1)]
        XCTAssertFalse(stage.didPlayerCrashWithOtherPlayer(player), "Both players are not touching")
        
        var playerLocations = [StageLocation(x: 0, y: 5),
                        StageLocation(x:1, y:5),
                        StageLocation(x:2, y:5)]
        player.locations = playerLocations
        
        player2Locations = [ StageLocation(x:1, y:4),
            StageLocation(x:1, y:5),
            StageLocation(x:1, y:6) ]
        player2.locations = player2Locations
        
        // This is an invalid case becuase as soon as a player touches with its head other player, the player should die. Just testing for completion
        XCTAssertFalse(stage.didPlayerCrashWithOtherPlayer(player), "The players bodies are crossing but the heads are not touching")
        XCTAssertFalse(stage.didPlayerCrashWithOtherPlayer(player2), "The players bodies are crossing but the heads are not touching")
    }
    
    func testDidPlayerCrash() {
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        let player = PlayerMock()
        stage.addElement(player)
        
        XCTAssertTrue(stage.didPlayerCrash(player), "Player is on an obstacle location thus it should crash")
        
        player.locations = [StageLocation(x: 1, y: 1)]
        XCTAssertFalse(stage.didPlayerCrash(player), "Player is not on an obstacle location thus it should not crash")
        
        player.deactivate()
    }

    func testDidPlayerSecuredAnTarget() {
        
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        var playerLocations = [
            StageLocation(x:1, y:1),
            StageLocation(x:1, y:2)
            ]
        let player = Player(locations: playerLocations, direction: .Up)
        stage.addElement(player)
       
        let target = Target(locations: [StageLocation(x: 1, y: 1)], value: 10)
        stage.addElement(target)
    
        let secondTarget = Target(locations: [StageLocation(x: 8, y: 8)], value: 5)
        stage.addElement(secondTarget)
        
        var securedTarget = stage.didPlayerSecureTarget(player)
        XCTAssertEqual(securedTarget!, target, "Player did secure a target")
        
        playerLocations = [
            StageLocation(x:10, y:15),
            StageLocation(x:10, y:16)
        ]
        player.locations = playerLocations
        securedTarget = stage.didPlayerSecureTarget(player)
        XCTAssertNil(securedTarget, "Player did not secure a target")
        
        secondTarget.destroy()
        target.destroy()
        player.deactivate()
    }
    
    func testDidPlayerEatItself() {
        
        stage = Stage.sharedStage
        stage.configurator = level1Config
        
        var playerLocations = [ StageLocation(x: 10, y: 15),
            StageLocation(x: 10, y: 16),
            StageLocation(x: 9, y: 16),
            StageLocation(x: 9, y: 15),
            StageLocation(x: 10, y: 15),
            StageLocation(x: 11, y: 15)]
        
        var player = Player(locations: playerLocations, direction: Direction.Up)
        XCTAssertTrue(stage.didPlayerEatItself(player), "Yes, it did :(")
        
        playerLocations = stage.randomLocations(5, direction: .Down)
        player = Player(locations: playerLocations, direction: .Down)
        XCTAssertFalse(stage.didPlayerEatItself(player), "No, it didn't :)")
    }

    func testNumberOfActivePlayers() {

        stage = Stage.sharedStage
        stage.configurator = level1Config

        let player1Locations = stage.randomLocations(5, direction: .Down)
        let player1 = Player(locations: player1Locations, direction: .Down)

        let player2Locations = stage.randomLocations(5, direction: .Up)
        let player2 = Player(locations: player2Locations, direction: .Up)

        stage.addElement(player1)
        stage.addElement(player2)

        var activePlayers = stage.numberOfActivePlayers()
        XCTAssertEqual(activePlayers, 2, "There should be 2 active players")

        player1.deactivate()

        activePlayers = stage.numberOfActivePlayers()
        XCTAssertEqual(activePlayers, 1, "There should be 1 active player")


        player2.deactivate()

        activePlayers = stage.numberOfActivePlayers()
        XCTAssertEqual(activePlayers, 0, "There should be no active players")
    }
    
}

extension StageTests: StageDelegate {

    func broadcastElementDidChangeDirectionEvent(element: StageElementDirectable) {

    }

    func broadcastElementDidMoveEvent(element: StageElement) {

    }

    func broadcastElementDidDeactivate(element: StageElement) {
        
    }
    
    func elementLocationDidChange(element: StageElement, inStage stage: Stage) {
    }

    func validateGameLogicUsingElement(element: StageElement, inStage stage: Stage) {
        elementLocationDidChangeExpectation?.fulfill()
    }
}