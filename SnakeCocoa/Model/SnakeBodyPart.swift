//
//  SnakeBodyPart.swift
//  SnakeSwift
//
//  Created by PartyMan on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

struct SnakeBodyPart : Printable {
    
    // MARK: Properties
    
    enum SnakeBodyPartType {
        case Head
        case Body
    }
    
    enum SnakeBodyPartState {
        case WaitingForDirectionChange
        case DirectionChangedWaitingForReset
    }
    
    var type: SnakeBodyPartType
    var locationX: Float
    var locationY: Float
    
    private var _direction: Direction {
        willSet {
            if bodyPartState == .WaitingForDirectionChange {
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
            if shouldSetDirection(newDirection, basedOnCurrentState: bodyPartState) {
                _direction = newDirection
            }
        }
    }
    
    // For rendering purposes
    var oldDirection: Direction? {
        get { return _oldDirection}
    }
    
    private var bodyPartState: SnakeBodyPartState
    
    var description: String {
        return "x: \(locationX) y: \(locationY) direction: \(_direction) oldDirection: \(_oldDirection)"
    }
    
    // MARK: Initializers
    
    init(x: Float, y: Float, direction: Direction) {
        self.type = SnakeBodyPartType.Body
        locationX = x
        locationY = y
        _direction = direction
        bodyPartState = SnakeBodyPartState.WaitingForDirectionChange
    }
    
    init(x:Float, y: Float, direction: Direction, type: SnakeBodyPartType) {
        self.init(x: x, y: y, direction: direction)
        self.type = type
    }
    
    // MARK: Instance methods
    
    private func shouldSetDirection(newDirection: Direction, basedOnCurrentState bodyPartState: SnakeBodyPartState) -> Bool {
        switch bodyPartState {
        case .WaitingForDirectionChange:
            return !Direction.sameAxisDirections(_direction, direction2: newDirection)
        case .DirectionChangedWaitingForReset:
            return Direction.sameAxisDirections(_direction, direction2: newDirection)
        }
    }
    
    private mutating func transitionToProperState() {
        switch bodyPartState {
        case .WaitingForDirectionChange:
            bodyPartState = .DirectionChangedWaitingForReset
        case .DirectionChangedWaitingForReset:
            bodyPartState = .DirectionChangedWaitingForReset
        }
    }
    
    mutating func resetBodyPartState() {
        bodyPartState = .WaitingForDirectionChange
    }
}