//
//  Direction.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/9/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

enum Direction : UInt8, Printable{
    case Right = 1
    case Left = 2
    case Up = 4
    case Down = 8
    
    static private var count: UInt8 {
        return 4
    }
    
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
        let randShift = arc4random_uniform(UInt32(Direction.count))
        let rand = 1 << randShift
        return Direction(rawValue: UInt8(rand))!
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
    
    static func reversedDirection(direction: Direction) -> Direction {
        
        var axisMask: UInt8
        
        switch direction {
        case .Right, .Left:
            axisMask = 0b00000011
        case .Up, .Down:
            axisMask = 0b00001100
        }
        
        var tmpDirection = direction.rawValue
        let axisDirection = tmpDirection & axisMask
        let reversedDirection = ~axisDirection & axisMask
        
        return Direction(rawValue: reversedDirection)!
    }
    
    static func inversedDirection(direction: Direction) -> Direction {
        
        let inversedDirections = direction.rawValue << 2
        
        let lowerInverseDirection = inversedDirections & 0b00001111
        let upperInversedDirection = (inversedDirections & 0b11110000) >> 4
        
        let inversedDirection = max(lowerInverseDirection, upperInversedDirection)
        
        return Direction(rawValue: inversedDirection)!
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
