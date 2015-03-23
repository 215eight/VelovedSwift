//
//  Apple.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class Apple: StageElement {
   
    // MARK: Properties
    
    let value: Int = 0
    var timer: NSTimer!
    var timerInterval: NSTimeInterval = 20.0 {
        didSet {
            if timerInterval <= 5.0 {
                timerInterval = oldValue
            }
        }
    }
    private var timerIntervalDelta = 0.02
    
    weak var delegate: StageElementDelegate?
    
    convenience init () {
        let zeroLocation = StageLocation(x: 0, y: 0)
        self.init(locations: [zeroLocation], value: 0)
    }
    
    // MARK: Initializers
    init(locations: [StageLocation], value: Int) {
        super.init(locations: locations)
        if value > 0 { self.value = value }
        
        scheduleUpdateLocationTimer()
    }
    
    func scheduleUpdateLocationTimer() {
        
        timer = NSTimer(timeInterval: timerInterval,
            target: self, selector: "updateLocation",
            userInfo: nil,
            repeats: true)
        
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        timer.fire()
    }
    
    func decrementTimer() {
        timerInterval -= timerIntervalDelta
        timer.invalidate()
        scheduleUpdateLocationTimer()
    }
    
    func wasEaten() {
        updateLocation()
        decrementTimer()
    }
    
    func updateLocation() {
        if delegate != nil {
            locations = delegate!.randomLocations(locations.count)
            delegate!.elementLocationDidChange(self)
        }
    }
    
    func destroy() {
        delegate = nil
        timer.invalidate()
        timer = nil
    }
    
}