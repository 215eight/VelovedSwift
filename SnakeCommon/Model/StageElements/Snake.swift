//
//  Snake.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class Snake : StageElementDirectable {

    override public class var elementName : String {
        return "Snake"
    }
    
    weak var delegate: StageElementDelegate?
    
    var moveTimer: dispatch_source_t!
    var speed: UInt64 = NSEC_PER_SEC / 2 {
        didSet {
            if speed <  NSEC_PER_SEC / 8 {
                speed = oldValue
            }
        }
    }
    let speedDelta = NSEC_PER_SEC / 20
    
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
    
    public var type: SnakeType = SnakeType.Solid
    
    private var shouldGrow = false
    
    
    public override init(locations: [StageLocation], direction: Direction) {
        if locations.isEmpty{
            assertionFailure("A snake should at least have a head")
        }
        
        super.init(locations: locations, direction: direction)
        
    }

    deinit {
        kill()
    }
    
    func invalidateMoveTimer() {
        if moveTimer != nil { dispatch_source_cancel(moveTimer) }
        moveTimer = nil
    }
    
    func animate() {
        let timerFactory = TimerFactory.sharedTimerFactory
        moveTimer = timerFactory.getTimer(speed) {
            self.move()
        }
        
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
        locations.removeAll(keepCapacity: false)
    }
    
    func didEatApple() {
        shouldGrow = true
        speed -= speedDelta
        invalidateMoveTimer()
        animate()
    }

}

extension Snake: StageLocationDescription {
    override var locationDesc: String {
        return "#"
    }
}