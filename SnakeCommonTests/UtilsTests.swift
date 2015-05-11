//
//  UtilsTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class UtilsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testContainsElementWithinArray() {
        
        let numberArray = [1,2,3,4,5]
        let strArray = ["a", "b", "c", "d"]
        let stageLocationArray = [ StageLocation(x: 0, y: 0),
                                StageLocation(x:0, y:1),
                                StageLocation(x:0, y:2),
                                StageLocation(x:0, y:3)]
        
        XCTAssertFalse(contains(numberArray, 0), "Zero is not part of numbers array")
        XCTAssertTrue(contains(numberArray, 5), "Five is part of the numbers array")
        //XCTAssertTrue(contains(numberArray, "s"), "This should not compile")
        
        XCTAssertFalse(contains(strArray, "z"), "Z is not part of the strings array")
        XCTAssertTrue(contains(strArray, "a"), "A is part of the strings array")
        //XCTAssertTrue(contains(strArray, CGPointZero), "This should not compile")
        
        XCTAssertFalse(contains(stageLocationArray, StageLocation(x: 10, y: 10)), "(10, 10) is not in the locations array")
        XCTAssertTrue(contains(stageLocationArray, StageLocation(x: 0, y: 3)), "(0,3) is in the locations array")
        
    }
    
    func testContainsPredicate() {
        
        let numberArray = [1,2,3,4,5]
        let strArray = ["a", "b", "c"]
        
        var predicate = containsPredicate(numberArray, 5)
        var isInArray = predicate(numberArray)
        
        XCTAssertTrue(isInArray, "5 in in numbers array")
        
        predicate = containsPredicate(numberArray, 0)
        isInArray = predicate(numberArray)
        
        XCTAssertFalse(isInArray, "O is not in numbers array")
    }
    
    func testContainsElementWithinArrayOfArrays() {
    
        let numbersArray = [[1,2], [2,3], [3,4]]
        
        //var predicate = containsPredicate(numbersArray, 0)
        //let aisInSequence = contains(numbersArray, { return containsPredicate($0, 7) } )
        
        var isInSequence = contains(numbersArray) { (element: Array<Int>) -> Bool in return contains(element, 0) }
        XCTAssertFalse(isInSequence, "0 is not in the numbers array")
        
        isInSequence = contains(numbersArray) { (element: Array<Int>) -> Bool in return contains(element, 2) }
        XCTAssertTrue(isInSequence, "2 is in the numbers array")
        
        let stageLocations = [ [StageLocation(x:0, y:0), StageLocation(x:0, y:1)],
                            [StageLocation(x:10, y:10), StageLocation(x:11, y:10)],
                            [StageLocation(x:20, y:0), StageLocation(x:20, y:1), StageLocation(x:20, y:2)]
                            ]
        
        var location = StageLocation(x:100, y:100)
        isInSequence = contains(stageLocations) { (e: Array<StageLocation>) -> Bool in return contains(e, location) }
        XCTAssertFalse(isInSequence, "(100, 100) is not in the stage locations array")
        
        location = StageLocation(x:10, y:10)
        isInSequence = contains(stageLocations) { (e: Array<StageLocation>) -> Bool in return contains(e, location) }
        XCTAssertTrue(isInSequence, "(10,10) is in the stage locations array")
    }
    
    func testDuplicates() {
        
        let uniqueNumbers = [1,2,3,4,5]
        let duplicateNumbers = [1,2,3,4,2,100]
        let uniqueStrings = ["a", "b", "c"]
        let duplicateStrings = ["a", "b", "a"]
        let uniqueLocations = [StageLocation(x: 0, y: 0), StageLocation(x: 0, y: 1), StageLocation(x: 0, y: 2)]
        let duplicateLocations = [StageLocation(x: 0, y: 0), StageLocation(x: 0, y: 1), StageLocation(x: 0, y: 0)]
        
        var hasDuplicates = duplicates(uniqueNumbers)
        XCTAssertFalse(hasDuplicates, "Unique numbers has no duplicates")
        
        hasDuplicates = duplicates(duplicateNumbers)
        XCTAssertTrue(hasDuplicates, "Duplicate numbers has duplicates")
        
        hasDuplicates = duplicates(uniqueStrings)
        XCTAssertFalse(hasDuplicates, "Unique strings has no duplicates")
        
        hasDuplicates = duplicates(duplicateStrings)
        XCTAssertTrue(hasDuplicates, "Duplicate strings has duplicates")
        
        hasDuplicates = duplicates(uniqueLocations)
        XCTAssertFalse(hasDuplicates, "Unique locations has no duplicates")
        
        hasDuplicates = duplicates(duplicateLocations)
        XCTAssertTrue(hasDuplicates, "Duplicate locations has duplicates")
    }
    
    func testIntersectsElementArray() {
    
        let target = [[1,2],[3,4],[5]]
        let locations = [ [StageLocation(x: 0, y: 0), StageLocation(x:0, y:1)],
                          [StageLocation(x:0, y:2), StageLocation(x:0, y:3)]
                        ]
        
        var source = [6,7,8,9,10]
        XCTAssertFalse(intersects(source, target), "None of the numbers are equal in both arrays")
        
        source = [0,20,30,2]
        XCTAssertTrue(intersects(source, target), "Number 2 is in both arrays")
        
        var sourceLocations = [ StageLocation(x:10, y:10), StageLocation(x:15, y:15) ]
        XCTAssertFalse(intersects(sourceLocations, locations), "None of the locations intersect")
        
        sourceLocations = [ StageLocation(x:10, y:10), StageLocation(x:0, y:3) ]
        XCTAssertTrue(intersects(sourceLocations, locations), "Locations intersect")
    }
    
    func testIntersectsElement() {
        let target = [[1,2],[3,4],[5]]
        let locations = [ [StageLocation(x: 0, y: 0), StageLocation(x:0, y:1)],
                          [StageLocation(x:0, y:2), StageLocation(x:0, y:3)]
                        ]
        
        var element = 10
        XCTAssertFalse(intersects(element, target), "None of the number are equal in both arrays")
        
        element = 2
        XCTAssertTrue(intersects(element, target), "Number 2 is in both arrays")
        
        var elementLocations = StageLocation(x:10, y:10)
        XCTAssertFalse(intersects(elementLocations, locations), "None of the locations intersect")
        
        elementLocations = StageLocation(x:0, y:3)
        XCTAssertTrue(intersects(elementLocations, locations), "Locations intersect")

    }
    
    func testIntersectsStageElementArray() {
        
        let stage = Stage.sharedStage
        stage.configurator = StageConfiguratorLevel1(size: StageSize(width: 3, height: 3))
        let stageObstacles = stage.elements[Obstacle.elementName]!
        let obstacle = Obstacle(locations: [StageLocation(x: 0, y: 0)])

        var intersectElements = intersects([obstacle], stageObstacles)
        XCTAssertEqual(intersectElements, [obstacle], "It does intersect")
        
        // Test different instances that are subtypes of StageElement
        var appleLocations = [StageLocation(x: 10, y: 10)]
        let firstApple = Apple(locations: appleLocations, value: 10)
        
        appleLocations = [StageLocation(x:30, y: 30)]
        let secondApple = Apple(locations: appleLocations, value: 15)
        
        let apples = [firstApple, secondApple]
        
        var snakeLocations = [StageLocation(x: 4, y: 8), StageLocation(x:4, y:9)]
        let firstSnake = Snake(locations: snakeLocations, direction: .Up)
        
        snakeLocations = [StageLocation(x: 30, y: 30), StageLocation(x: 29, y: 30)]
        let secondSnake = Snake(locations: snakeLocations, direction: .Right)
        
        var snakes = [firstSnake, secondSnake]
        
        intersectElements = intersects(apples, snakes)
        XCTAssertEqual(intersectElements, [secondApple], "Second apple intersects with second snake")
        
        snakes.removeLast()
        secondSnake.kill()
        
        intersectElements = intersects(apples, snakes)
        XCTAssertTrue(intersectElements.count == 0, "AFter removing second snake, none of the apples intersect with a snake")
        
        
        apples.map(){ $0.destroy() }
        snakes.map(){ $0.kill() }
    }
    
    func testCharUnicodeValueParam() {
        
    }
}
