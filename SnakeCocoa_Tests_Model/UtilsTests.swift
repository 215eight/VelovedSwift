//
//  UtilsTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
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
        //let isInSequence = contains(numbersArray, { return containsPredicate($0, 7) } )
        
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
}
