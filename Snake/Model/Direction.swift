//
//  Direction.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/9/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

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
    
    var inverse: Direction {
        switch self {
        case .Up:
            return .Down
        case .Down:
            return .Up
        case .Right:
            return .Left
        case .Left:
            return .Right
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
        case .Up, .Down:
            if (direction2 == .Up || direction2 == .Down) {
                return true
            }
        case .Left, .Right:
            if (direction2 == .Left || direction2 == .Right) {
                return true
            }
        }
        return false
    }
    
    static func degreeRotationChange(fromDirection: Direction, toDirection: Direction) -> Float {
        switch fromDirection {
        case .Up:
            switch toDirection {
            case .Up: return 0
            case .Down: return Direction.degreesToRadians(180)
            case .Left: return Direction.degreesToRadians(+90)
            case .Right: return Direction.degreesToRadians(-90)
            }
        case .Down:
            switch toDirection {
            case .Up: return Direction.degreesToRadians(180)
            case .Down: return 0
            case .Left: return Direction.degreesToRadians(-90)
            case .Right: return Direction.degreesToRadians(+90)
            }
        case .Left:
            switch toDirection {
            case .Up: return Direction.degreesToRadians(-90)
            case .Down: return Direction.degreesToRadians(+90)
            case .Left: return 0
            case .Right: return Direction.degreesToRadians(180)
            }
        case .Right:
            switch toDirection {
            case .Up: return Direction.degreesToRadians(+90)
            case .Down: return Direction.degreesToRadians(-90)
            case .Left: return Direction.degreesToRadians(180)
            case .Right: return 0
            }
        }
    }
    
    static func degreesToRadians(degrees: Float) -> Float {
        return degrees * Float(M_PI / 180)
    }
}
