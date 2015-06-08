//
//  Player.swift
//  GameSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class Player: StageElementDirectable {

    override public class var elementName : String {
        return "Player"
    }
    
    weak var delegate: StageElementDelegate?
    
    var moveTimer: dispatch_source_t!
    var speed: UInt64 = NSEC_PER_SEC / 1 {
        didSet {
            if speed <  NSEC_PER_SEC / 16 {
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
    
    public var type: PlayerType = PlayerType.Solid
    
    private var shouldGrow = false
    
    
    public override init(locations: [StageLocation], direction: Direction) {
        if locations.isEmpty{
            assertionFailure("A player should at least have a head")
        }
        
        super.init(locations: locations, direction: direction)
        
    }

    deinit {
        delegate = nil
        invalidateMoveTimer()
    }
    
    func invalidateMoveTimer() {
        if moveTimer != nil {
            dispatch_source_cancel(moveTimer)
            moveTimer = nil
        }
    }
    
    func animate() {
        let timerFactory = TimerFactory.sharedTimerFactory
        moveTimer = timerFactory.getTimer(speed) {
            self.move()
        }
        
    }
    
    func move() {

        if let _ = delegate {
            let firstPos = locations.first!
            
            let lastLocation = locations.removeLast()
            
            if shouldGrow {
                locations.append(lastLocation)
                shouldGrow = false
            }
            
            let newLocation = delegate!.destinationLocation(firstPos, direction: direction)
            locations.insert(newLocation, atIndex: 0)
            resetDirectionState()
        }

        delegate?.broadcastElementDidMoveEvent(self)
        delegate?.elementLocationDidChange(self)
    }
    
    
    func deactivate() {

        delegate = nil
        invalidateMoveTimer()
        emptyLocations()
    }
    
    func didSecureTarget() {
        shouldGrow = true
        speed -= speedDelta
        invalidateMoveTimer()
        animate()
    }

    override func stageElementDirectionDidChange() {
        super.stageElementDirectionDidChange()

        delegate?.broadcastElementDidChangeDirectionEvent(self)
    }

}

extension Player: StageLocationDescription {
    override var locationDesc: String {
        return "#"
    }
}