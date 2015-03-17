//
//  AppleTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class AppleTests: XCTestCase, AppleDelegate {

    weak var didUpdateLocationExpectation: XCTestExpectation?
    
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
        
        XCTAssertTrue(apple.location? == nil, "Location is nil until the Apple is added to a stage")
        XCTAssertEqual(apple.value, 5, "Apple is 5 pionts")
        XCTAssertNil(apple.delegate, "Apple has a delegate property")
        XCTAssertEqual(invalidApple.value, 0, "Apple value must be positive")
        XCTAssertEqual(Apple.className(), "Apple", "Apple class name")
    }
    
    func testDelegateUpdateLocation() {
        
        didUpdateLocationExpectation = self.expectationWithDescription("didUpdateLocationExpectation")
        
        let apple = AppleMock()
        apple.delegate = self
        
        self.waitForExpectationsWithTimeout(2, handler: {
            (error) in
            XCTAssertEqual(apple.location!, StageLocation(x: 0, y: 0), "Location should be updated")
        })
    }
    
    func testDestroyApple() {
        
        let apple = Apple()
        let timer = apple.timer
        apple.destroy()
        
        XCTAssertFalse(timer.valid, "Timer should no longer be valid")
        XCTAssertNil(apple.timer, "Reference to the timer should be released")
    }
    
    // MARK: AppleDelegate methods
    func updateAppleLocation(apple: Apple) -> StageLocation {
        apple.timer.invalidate()
        didUpdateLocationExpectation?.fulfill()
        return StageLocation(x: 0, y: 0)
    }
}
