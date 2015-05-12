//
//  SnakeConfiguration.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/10/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class SnakeConfiguration: NSObject, NSCoding {

    private var locationsSerializable = [StageLocationSerializable]()
    var locations: [StageLocation] {
        return locationsSerializable.map() {
            StageLocation(x: Int($0.x), y:Int($0.y))
        }
    }
    let direction: Direction
    let type: SnakeType

    init(locations: [StageLocation], direction: Direction, type: SnakeType) {
        self.locationsSerializable = locations.map() {
            StageLocationSerializable(location: $0)
        }
        self.direction = direction
        self.type = type
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(locationsSerializable, forKey: MPCMessageKey.Locations.rawValue)
        aCoder.encodeInt32(Int32(direction.rawValue), forKey: MPCMessageKey.SnakeDirection.rawValue)
        aCoder.encodeInt32(Int32(type.rawValue), forKey: MPCMessageKey.SnakeType.rawValue)
    }

    required public init(coder aDecoder: NSCoder) {

        self.locationsSerializable = aDecoder.decodeObjectForKey(MPCMessageKey.Locations.rawValue) as [StageLocationSerializable]
        self.direction = Direction(rawValue: UInt8(aDecoder.decodeInt32ForKey(MPCMessageKey.SnakeDirection.rawValue)))!
        self.type = SnakeType(rawValue: UInt(aDecoder.decodeInt32ForKey(MPCMessageKey.SnakeType.rawValue)))!

        super.init()
    }

}