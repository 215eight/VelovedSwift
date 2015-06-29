//
//  Target.swift
//  VelovedGame
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public enum TargetMode: UInt8 {
    case SelfUpdate
    case NoUpdate
}

public class Target: StageElement {
   
    // MARK: Properties

    override public class var elementName: String {
        return "Target"
    }

    let value: Int = DefaultTargetValue
    let mode: TargetMode = .SelfUpdate
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
    
    convenience init(locations: [StageLocation], value: Int) {
        self.init(locations: locations, value: value, mode: TargetMode.SelfUpdate)
    }

    init(locations: [StageLocation], value: Int, mode: TargetMode) {
        super.init(locations: locations)
        if value > 0 { self.value = value }
        self.mode = mode
    }
    
    func animate() {

        if mode == .SelfUpdate {
            let timerFactory = TimerFactory.sharedTimerFactory
            timer = timerFactory.getTimer(timerInterval) {
                self.updateLocation()
            }
        }
    }
    
    func decrementTimer() {
        timerInterval -= timerIntervalDelta
        invalidateTimer()
        animate()
    }
    
    func wasSecured() {
        updateLocation()
        decrementTimer()
    }

    func wasSecured(locations: [StageLocation]) {
        updateLocation(locations)
        decrementTimer()
    }
    
    func updateLocation() {
        if let _ = delegate {
            locations = delegate!.randomLocations(DefaultTargetSize)
            delegate?.broadcastElementDidMoveEvent(self)
            updateLocation(locations)
        }
    }

    func updateLocation(locations: [StageLocation]) {
        self.locations = locations
        delegate?.elementLocationDidChange(self)
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

extension Target: StageLocationDescription {
    override var locationDesc: String {
        return "@"
    }
}