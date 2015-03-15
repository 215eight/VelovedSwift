//
//  AppleTests.swift
//  SnakeSwift
//
//  Created by PartyMan on 3/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import XCTest

class AppleTests: XCTestCase, AppleDelegate {

    var didUpdateLocationExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProperties() {
        
        let apple = Apple(value:5)
        let invalidApple = Apple(value: -10)
        
        XCTAssertEqual(apple.value, 5, "Apple is 5 pionts")
        XCTAssertEqual(invalidApple.value, 0, "Apple value must be positive")
    }
    
    func testDelegateUpdateLocation() {
        
        didUpdateLocationExpectation = self.expectationWithDescription("update location")
        
        let apple = AppleMock()
        apple.delegate = self
        
        self.waitForExpectationsWithTimeout(2, handler: nil)
        
    }
    
    // MARK: AppleDelegate methods
    func updateAppleLocation(apple: Apple) -> StageLocation {
        self.didUpdateLocationExpectation.fulfill()
        return StageLocation(x: 0, y: 0)
    }
}
