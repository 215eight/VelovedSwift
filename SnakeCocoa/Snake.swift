//
//  Snake.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit


enum Direction : UInt, Printable{
    case Up
    case Down
    case Right
    case Left
    
    var description: String {
        switch self {
        case .Up:
            return "Up"
        case .Down:
            return "Down"
        case .Right:
            return "Right"
        case .Left:
            return "Left"
        }
    }
    
    static func randomDirection() -> Direction {
        var maxValue : UInt = 0
        while let _ = Direction(rawValue: ++maxValue) {}
        let rand = arc4random_uniform(UInt32(maxValue))
        return Direction(rawValue: UInt(rand))!
    }
    
    static func sameAxisDirections(direction1: Direction, direction2: Direction) -> Bool {
        switch direction1 {
        case .Up:
            if (direction2 == .Up || direction2 == .Down) {
                return true
            }
        case .Down:
            if (direction2 == .Up || direction2 == .Down) {
                return true
            }
        case .Left:
            if (direction2 == .Left || direction2 == .Right) {
                return true
            }
        case .Right:
            if (direction2 == .Left || direction2 == .Right) {
                return true
            }
        }
        return false
    }
   
    static func degreeRotationChange(fromDirection: Direction, toDirection: Direction) -> CGFloat {
        switch fromDirection {
        case .Up:
            switch toDirection {
            case .Up: return 0
            case .Down: return Direction.degreesToRadians(180)
            case .Left: return Direction.degreesToRadians(-90)
            case .Right: return Direction.degreesToRadians(90)
            }
        case .Down:
            switch toDirection {
            case .Up: return Direction.degreesToRadians(180)
            case .Down: return 0
            case .Left: return Direction.degreesToRadians(90)
            case .Right: return Direction.degreesToRadians(-90)
            }
        case .Left:
            switch toDirection {
            case .Up: return Direction.degreesToRadians(90)
            case .Down: return Direction.degreesToRadians(-90)
            case .Left: return 0
            case .Right: return Direction.degreesToRadians(180)
            }
        case .Right:
            switch toDirection {
            case .Up: return Direction.degreesToRadians(-90)
            case .Down: return Direction.degreesToRadians(90)
            case .Left: return Direction.degreesToRadians(180)
            case .Right: return 0
            }
        }
    }
    
    static func degreesToRadians(degrees: Float) -> CGFloat {
        return CGFloat(degrees * Float(M_PI / 180))
    }
}

class Snake : NSObject {
    
    // MARK: Properties
    var snakeBody = [SnakeBodyPart]()
    var xLowerBound: Float
    var yLowerBound: Float
    var xUpperBound: Float
    var yUpperBound: Float
    var bodySize = 5
//    private var lockDirection = false
//    private var direction: Direction {
//        didSet(oldDirection) {
//            if Direction.sameAxisDirections(oldDirection, direction2: direction) {
//                direction = oldDirection
//                lockDirection = false
//            }
//        }
//    }
    
    var snakeHead : SnakeBodyPart {
        get {
            return snakeBody[0]
        }
        set(newHead) {
            snakeBody.insert(newHead, atIndex: 0)
        }
    }
    var tailBodyPart: SnakeBodyPart!
    
    
    // There is a possibility that two direction moves can happen during snake moves leading to an inconsistent stage.
    // To solve this issue, the direction variable should be successfully set only one time between moves.
    // After the snake moves, the lock should be released
    
//    func setDirection(direction: Direction) {
//        if !lockDirection {
//            lockDirection = true
//            self.direction = direction
//        }
//    }
    
    // MARK: Initializers
    
    init(xLowerBound: Float, xUpperBound: Float, yLowerBound: Float, yUpperBound: Float) {
        
        // Bounds limits are used to determine the range of potential locations of a snake body part
        // Since the snake body part location is based on its center, the limits need to be adjusted by 0.5
        // Each potential locaiton is measured by increments of 1.0
        self.xLowerBound = xLowerBound + 0.5
        self.xUpperBound = xUpperBound - 0.5
        self.yLowerBound = yLowerBound + 0.5
        self.yUpperBound = yUpperBound - 0.5
        
        super.init()
        
        // Get random head origin and build body
        buildBody(randomHeadOrigin())
    }
    
    // MARK: Class Methods
    
    func buildBody(head: SnakeBodyPart) {
    
        
        // Add head to the body
        snakeBody.append(head)
        
        var lastBodyPart = snakeBody.last
        for index in 1 ... bodySize {
            
            var newBodyPart: SnakeBodyPart
            
            switch head.direction {
            case .Up:
                newBodyPart = SnakeBodyPart(x: lastBodyPart!.locationX, y: lastBodyPart!.locationY + 1, direction: head.direction)
            case .Down:
                newBodyPart = SnakeBodyPart(x: lastBodyPart!.locationX, y: lastBodyPart!.locationY - 1, direction: head.direction)
            case .Left:
                newBodyPart = SnakeBodyPart(x: lastBodyPart!.locationX + 1, y: lastBodyPart!.locationY, direction: head.direction)
            case .Right:
                newBodyPart = SnakeBodyPart(x: lastBodyPart!.locationX - 1, y: lastBodyPart!.locationY, direction: head.direction)
            }
            
            snakeBody.append(newBodyPart)
            lastBodyPart = newBodyPart
        }
    }
    
    func randomHeadOrigin() -> SnakeBodyPart {
        
        // Create an inset rectangle of the snake size so it isn't too close to the border
        let xLowerBoundInset = xLowerBound + Float(bodySize)
        let xUpperBoundInset = xUpperBound - Float(bodySize)
        let yLowerBoundInset = yLowerBound + Float(bodySize)
        let yUpperBoundInset = yUpperBound - Float(bodySize)
        
        let rangeX = UInt32(xUpperBoundInset) - UInt32(xLowerBoundInset)
        let locationX = xLowerBoundInset + Float(arc4random_uniform(rangeX))
        
        let rangeY = UInt32(yUpperBoundInset) - UInt32(yLowerBoundInset)
        let locationY = yLowerBoundInset + Float(arc4random_uniform(rangeY))
        
        return SnakeBodyPart(x: locationX, y: locationY, direction: Direction.randomDirection(), type: SnakeBodyPart.SnakeBodyPartType.Head)
    }
    
    // MARK: Instance Methods
    func move(#continuous: Bool) {
        
        precondition(snakeBody.count >= 2, "Snake should be at lest 2 units long")
        
        // Save the tail body part
        if let lastPoint = snakeBody.last {
            tailBodyPart = lastPoint
        }
        
        // Shift all positions, except the origin, by one starting from the last position
        for index in reverse(1 ..< snakeBody.count) {
            snakeBody[index] = snakeBody[index-1]
        }
        
        // Generate new origin
        let head = snakeHead
        if continuous {
            var newLocation : Float
            switch head.direction {
            case .Up:
                (head.locationY - 1.0 < yLowerBound) ? (newLocation = yUpperBound) : (newLocation = head.locationY - 1)
                snakeHead = SnakeBodyPart(x: head.locationX, y: newLocation, direction: head.direction)
            case .Down:
                (head.locationY + 1.0 > yUpperBound) ? (newLocation = xLowerBound) : (newLocation = head.locationY + 1)
                snakeHead = SnakeBodyPart(x: head.locationX, y: newLocation, direction: head.direction)
            case .Right:
                (head.locationX + 1.0 > xUpperBound) ? (newLocation = yLowerBound) : (newLocation = head.locationX + 1)
                snakeHead = SnakeBodyPart(x: newLocation, y: head.locationY, direction: head.direction)
            case .Left:
                (head.locationX - 1.0 < xLowerBound) ? (newLocation = xUpperBound) : (newLocation = head.locationX - 1)
                snakeHead = SnakeBodyPart(x: newLocation, y: head.locationY, direction: head.direction)
            }
        }else {
            var newLocation : Float
            
            switch head.direction {
            case .Up:
                newLocation = head.locationY - 1.0
                snakeHead = SnakeBodyPart(x: head.locationX, y: newLocation, direction: head.direction)
            case .Down:
                newLocation = head.locationY + 1.0
                snakeHead = SnakeBodyPart(x: head.locationX, y: newLocation, direction: head.direction)
            case .Right:
                newLocation = head.locationX + 1.0
                snakeHead = SnakeBodyPart(x: newLocation, y: head.locationY, direction: head.direction)
            case .Left:
                newLocation = head.locationX - 1.0
                snakeHead = SnakeBodyPart(x: newLocation, y: head.locationY, direction: head.direction)
            }
        }
        snakeBody[1].direction = snakeHead.direction
        
        // Release direction property lock
        //lockDirection = false
    }
    
    func grow() {
        snakeBody.insert(tailBodyPart, atIndex: snakeBody.count)
    }
    
    func destroy() {
        snakeBody.removeAll(keepCapacity: false)
    }
    
}

struct SnakeBodyPart : Printable{
    
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
    var _direction: Direction{
        willSet {
            _oldDirection = _direction
        }
        didSet {
            transitionToProperState()
        }
    }
    var _oldDirection: Direction?
    
    
    var direction: Direction {
        get { return _direction }
        set(newDirection) {
            if shouldSetDirection(newDirection, basedOnCurrentState: bodyPartState) {
                _direction = newDirection
            }
        }
    }
    
    private var bodyPartState: SnakeBodyPartState
    
    var description: String {
        return "x: \(locationX) y: \(locationY) direction: \(_direction) oldDirection: \(_oldDirection)"
    }
    
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


