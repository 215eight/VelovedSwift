//
//  TimerFactoryTests.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/1/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import Foundation

class TimerFactoryTests: XCTestCase {

    weak var timerExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetTimer() {
        
        timerExpectation = self.expectationWithDescription("Timer Expectation")
        
        var factory = TimerFactory.sharedTimerFactory
        
        
        var timer: dispatch_source_t! = factory.getTimer(NSEC_PER_SEC) {
            self.fulfillTimerExpectation()
        }

        self.waitForExpectationsWithTimeout(1.5) { (error) in
            dispatch_source_cancel(timer)
            timer = nil
        }
        
    }
    
    func testSameQueueIsUsedForEveryTimer() {
        
        weak var firstExpectation = self.expectationWithDescription("First Timer Expectation")
        weak var secondExpectation = self.expectationWithDescription("Second Timer Expectation")
        
        var factory = TimerFactory.sharedTimerFactory
        
        dispatch_suspend(timerQueue)
        
        var counter = 0
        var firstTimer = factory.getTimer(NSEC_PER_SEC / 2) {
            counter = counter + 1
            firstExpectation?.fulfill()
        }
        var secondTimer = factory.getTimer(NSEC_PER_SEC / 2) {
            counter = counter + 1
            secondExpectation?.fulfill()
        }
        
        XCTAssertEqual(counter, 0, "The timer's queue is suspended thus the timer's block should not be executed")
        
        dispatch_resume(timerQueue)
        
        self.waitForExpectationsWithTimeout(1) { (error) in
            dispatch_source_cancel(firstTimer)
            dispatch_source_cancel(secondTimer)
        }
        
    }
    
    // Target Actions
    func fulfillTimerExpectation(){
        timerExpectation.fulfill()
    }
}
