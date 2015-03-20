//
//  StageElementDirectable.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class StageElementDirectable: StageElement {
    
    enum DirectionState {
        case DirectionHasNotChanged
        case DirectionDidChange
    }
    
    private var directionState: DirectionState = .DirectionHasNotChanged
    
    private var _direction: Direction {
        willSet {
            if directionState == .DirectionHasNotChanged {
                _oldDirection = _direction
            }
        }
        didSet {
            transitionToProperState()
        }
    }
    
    private var _oldDirection: Direction?
    
    var direction: Direction {
        get { return _direction }
        set(newDirection) {
            if shouldSetDirection(newDirection, basedOnCurrentState: directionState) {
                _direction = newDirection
            }
        }
    }
    
    private func shouldSetDirection(newDirection: Direction, basedOnCurrentState bodyPartState: DirectionState) -> Bool {
        switch bodyPartState {
        case .DirectionHasNotChanged:
            return !Direction.sameAxisDirections(_direction, direction2: newDirection)
        case .DirectionDidChange:
            return Direction.sameAxisDirections(_direction, direction2: newDirection)
        }
    }
    
    private func transitionToProperState() {
        switch directionState {
        case .DirectionHasNotChanged:
            directionState = .DirectionDidChange
        case .DirectionDidChange:
            directionState = .DirectionDidChange
        }
    }
    
    func resetDirectionState() {
        directionState = .DirectionHasNotChanged
    }
    
    func steer(direction: Direction) {
        self.direction = direction
    }
    
    // MARK: Initializers
    init(location: StageLocation?, direction: Direction) {
        _direction = direction
        super.init(location: location)
    }
}