//
//  Apple.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class Apple: StageElement {
   
    // MARK: Properties
    
    let value: Int = 0
    var timer: dispatch_source_t!
    var timerInterval: UInt64 = 20 * NSEC_PER_SEC {
        didSet {
            if timerInterval <= 5 * NSEC_PER_SEC {
                timerInterval = oldValue
            }
        }
    }
    private var timerIntervalDelta = NSEC_PER_SEC / 2
    
    weak var delegate: StageElementDelegate?
    
    convenience init () {
        let zeroLocation = StageLocation(x: 0, y: 0)
        self.init(locations: [zeroLocation], value: 0)
    }
    
    deinit {
        destroy()
    }
    
    // MARK: Initializers
    init(locations: [StageLocation], value: Int) {
        super.init(locations: locations)
        if value > 0 { self.value = value }
        
    }
    
    func animate() {
        
        let timerFactory = TimerFactory.sharedTimerFactory
        
        timer = timerFactory.getTimer(timerInterval) {
           self.updateLocation()
        }
        
    }
    
    func decrementTimer() {
        timerInterval -= timerIntervalDelta
        invalidateTimer()
        animate()
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
        invalidateTimer()
    }
    
    func invalidateTimer() {
        if timer != nil { dispatch_source_cancel(timer) }
        timer = nil
    }
    
}

extension Apple: StageLocationDescription {
    override var locationDesc: String {
        return "@"
    }
}