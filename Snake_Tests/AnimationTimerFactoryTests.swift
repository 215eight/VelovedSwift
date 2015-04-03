//
//  AnimationTimerFactoryTests.swift
//  SnakeSwift
//
//  Created by PartyMan on 4/1/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import Foundation

class AnimationTimerFactoryTests: XCTestCase {

    weak var timerExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetAnimationTimer() {
        
        timerExpectation = self.expectationWithDescription("Timer Expectation")
        
        var factory = AnimationTimerFactory.sharedAnimationTimerFactory
        
        
        var timer: dispatch_source_t! = factory.getAnimationTimer(1.0) {
            self.fulfillTimerExpectation()
        }

        self.waitForExpectationsWithTimeout(2) { (error) in
            dispatch_source_cancel(timer)
            timer = nil
        }
        
    }
    
    func testSameQueueIsUsedForEveryTimer() {
        
        weak var firstExpectation = self.expectationWithDescription("First Timer Expectation")
        weak var secondExpectation = self.expectationWithDescription("Second Timer Expectation")
        
        var factory = AnimationTimerFactory.sharedAnimationTimerFactory
        
        let timerQueue = factory.timerQueue
        dispatch_suspend(timerQueue)
        
        var counter = 0
        var firstTimer = factory.getAnimationTimer(1) {
            counter = counter + 1
            firstExpectation?.fulfill()
        }
        var secondTimer = factory.getAnimationTimer(1) {
            counter = counter + 1
            secondExpectation?.fulfill()
        }
        
        XCTAssertEqual(counter, 0, "The timer's queue is suspended thus the timer's block should not be executed")
        
        dispatch_resume(timerQueue)
        
        self.waitForExpectationsWithTimeout(2) { (error) in
            dispatch_source_cancel(firstTimer)
            dispatch_source_cancel(secondTimer)
        }
        
    }
    
    // Target Actions
    func fulfillTimerExpectation(){
        timerExpectation.fulfill()
    }
}
