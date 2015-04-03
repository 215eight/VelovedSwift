//
//  GCDTimer.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/1/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

private let _sharedAnimationTimerFactory = AnimationTimerFactory()
private let timerQueueName = "com.partyland.AnimationTimerQueue"

class AnimationTimerFactory: NSObject {
    
    // MARK: Singleton Initializer
    
    class var sharedAnimationTimerFactory: AnimationTimerFactory {
        return _sharedAnimationTimerFactory
    }
    
    // MARK: Properties
    var timerQueue: dispatch_queue_t = dispatch_queue_create(timerQueueName, DISPATCH_QUEUE_SERIAL)
    private var leeway = NSEC_PER_SEC / 10
    
    // MARK: Instance methods
    func getAnimationTimer(interval: UInt64, block: dispatch_block_t?) -> dispatch_source_t {
        
        var timer: dispatch_source_t! = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timerQueue)

        if timer == 0 {
            assertionFailure("Error creating dispatch source")
        }
        
        let delay = Int64(interval)
        dispatch_source_set_timer(timer,
            dispatch_time(DISPATCH_TIME_NOW, delay),
            interval,
            leeway)
        
        if (block != nil) { dispatch_source_set_event_handler(timer, block) }
        dispatch_source_set_event_handler(timer,block)
        dispatch_resume(timer)
        
        return timer
    }
}
