//
//  GCDTimer.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/1/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

private let _sharedTimerFactory = TimerFactory()
private let timerQueueName = "com.partyland.ModelQueue"

class TimerFactory: NSObject {
    
    // MARK: Singleton Initializer
    
    class var sharedTimerFactory: TimerFactory {
        return _sharedTimerFactory
    }
    
    // MARK: Properties
    let timerQueue: dispatch_queue_t = dispatch_queue_create(timerQueueName, DISPATCH_QUEUE_SERIAL)
    private var leeway = NSEC_PER_SEC / 10
    
    // MARK: Instance methods
    func getTimer(interval: UInt64, block: dispatch_block_t?) -> dispatch_source_t {
        
        var timer: dispatch_source_t! = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timerQueue)

        if timer == nil {
            assertionFailure("Error creating dispatch source")
        }
        
        dispatch_source_set_timer(timer,
            dispatch_time(DISPATCH_TIME_NOW, Int64(interval)),
            interval,
            leeway)
        
        if (block != nil) {
            dispatch_source_set_event_handler(timer, block)
        }
        dispatch_resume(timer)
        
        return timer
    }
}
