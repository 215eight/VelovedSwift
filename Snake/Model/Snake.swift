//
//  Snake.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class Snake : StageElementDirectable {
    
    weak var delegate: StageElementDelegate?
    
    var moveTimer: NSTimer!
    var speed: NSTimeInterval = 0.5 {
        didSet {
            if speed < 0.05 {
                speed = oldValue
            }
        }
    }
    let speedDelta = 0.025
    
    var head: StageLocation {
        return locations.first!
    }
    
    var body: [StageLocation] {
        if locations.count == 1 {
            return []
        }else {
            let aRange = 1
            let bRange = locations.count - 1
            
            return Array(locations[aRange...bRange])
        }
    }
    
    private var shouldGrow = false
    
    
    override init(locations: [StageLocation], direction: Direction) {
        if locations.isEmpty{
            assertionFailure("A snake should at least have a head")
        }
        
        super.init(locations: locations, direction: direction)
        
        scheduleMoveTimer()
    }
    
    deinit {
        kill()
    }
    
    func invalidateMoveTimer() {
        moveTimer?.invalidate()
        moveTimer = nil
    }
    
    func scheduleMoveTimer() {
        moveTimer = NSTimer(timeInterval: speed,
            target: self,
            selector: "move",
            userInfo: nil,
            repeats: true)
        NSRunLoop.mainRunLoop().addTimer(moveTimer, forMode: NSDefaultRunLoopMode)
        moveTimer.fire()
    }
    
    func move() {
        if let _delegate = delegate {
            
            let firstPos = locations.first!
            
            let lastLocation = locations.removeLast()
            
            if shouldGrow {
                locations.append(lastLocation)
                shouldGrow = false
            }
            
            let newLocation = _delegate.destinationLocation(firstPos, direction: direction)
            locations.insert(newLocation, atIndex: 0)
            _delegate.elementLocationDidChange(self)
            resetDirectionState()
        }
    }
    
    func kill() {
        delegate = nil
        invalidateMoveTimer()
    }
    
    func grow() {
        shouldGrow = true
    }
    
    func didEatApple() {
        grow()
        speed -= speedDelta
        invalidateMoveTimer()
        scheduleMoveTimer()
    }
   
}