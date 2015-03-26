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
   
    override init(locations: [StageLocation], direction: Direction) {
        super.init(locations: locations, direction: direction)
        
        scheduleMoveTimer()
    }
    
    deinit {
        kill()
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
            
            locations.removeLast()
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
    
    func didEatApple() {
        speed -= speedDelta
        invalidateMoveTimer()
        scheduleMoveTimer()
    }
    
    func invalidateMoveTimer() {
        moveTimer?.invalidate()
        moveTimer = nil
    }
   
}