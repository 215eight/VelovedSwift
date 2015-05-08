//
//  StageLocation.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public struct StageLocation: Printable, Equatable, Comparable {
    
    public static func zeroLocation() -> StageLocation {
        return StageLocation(x:0, y:0)
    }
    
    public var x: Int = 0
    public var y: Int = 0
    
    var location: (Int, Int) {
        get {
            return (x, y)
        }
    }
    
    public var description: String {
        return "Stage Location x: \(x) y: \(y)"
    }
    
    public init(x: Int, y: Int) {
        if x > 0 { self.x = x }
        if y > 0 { self.y = y }
    }
    
    func destinationLocation(direction: Direction) -> StageLocation {

        var newX = self.x
        var newY = self.y
        
        switch direction {
        case .Up:
            newY -= 1
        case .Down:
            newY += 1
        case .Left:
            newX -= 1
        case .Right:
            newX += 1
        case .Unknown:
            assertionFailure("Unknown direction passed in")
        }
        
        return StageLocation(x: newX, y: newY)
    }
}

protocol StageLocationDescription {
    var locationDesc: String { get }
}

public func == (left: StageLocation, right: StageLocation) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}

public func != (left: StageLocation, right: StageLocation) -> Bool {
    return !(left == right)
}

public func <(lhs: StageLocation, rhs: StageLocation) -> Bool {
    if (lhs.y == rhs.y){
        if (lhs.x < rhs.x) {
            return true
        }else if (lhs.x > rhs.x) {
            return false
        }
    }else if (lhs.y > rhs.y) {
        return false
    }else{
        return true
    }
    return false
}
    