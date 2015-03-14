//
//  Array+IntersectsTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import XCTest

class Array_IntersectsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testContainsWithEmptyArray() {
        
        // Create array
        let array = [String]()
        
        // Validate
        XCTAssertFalse(array.contains("A"), "An empty array does not contain any types")
    }
    
    func testContainsValueExists() {
        
        // Create array
        let stringArray = ["a"]
        let intArray = [1,2,3]
        
        //Validate
        XCTAssertTrue(stringArray.contains("a"), "Array does contain a")
        XCTAssertFalse(intArray.contains(4), "Array does not contain 4")
        XCTAssertTrue(intArray.contains(2), "Array does contain 2")
    }
    
    func testIntersects() {
        let a = [1, 2]
        let b: [Int] = []
        let c = [2, 3]
        
        XCTAssertTrue(a.intersects(b).isEmpty, "Intersection is empty")
        XCTAssertEqual(a.intersects(c), [2], "C instersects with A")
    }
}
