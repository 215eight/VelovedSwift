//
//  SnakeConfiguration.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/10/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class SnakeConfiguration: NSObject, NSCoding {

    let locations: [StageLocation]
    let direction: Direction
    let type: SnakeType

    init(locations: [StageLocation], direction: Direction, type: SnakeType) {
        self.locations = locations
        self.direction = direction
        self.type = type
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        var _locationsX = [Int]()
        var _locationsY = [Int]()

        for location in locations {
            _locationsX.append(location.x)
            _locationsY.append(location.y)
        }

        aCoder.encodeObject(_locationsX, forKey: MPCMessageKey.SnakeLocationsX.rawValue)
        aCoder.encodeObject(_locationsY, forKey: MPCMessageKey.SnakeLocationsY.rawValue)
        aCoder.encodeInt32(Int32(direction.rawValue), forKey: MPCMessageKey.SnakeDirection.rawValue)
        aCoder.encodeInt32(Int32(type.rawValue), forKey: MPCMessageKey.SnakeType.rawValue)
    }

    required public init(coder aDecoder: NSCoder) {

        let _locationsX = aDecoder.decodeObjectForKey(MPCMessageKey.SnakeLocationsX.rawValue) as? [Int]
        let _locationsY = aDecoder.decodeObjectForKey(MPCMessageKey.SnakeLocationsY.rawValue) as? [Int]
        self.locations = [StageLocation]()

        for index in 0..._locationsX!.count-1 {
            locations.append(StageLocation(x: _locationsX![index], y: _locationsY![index]))
        }

        self.direction = Direction(rawValue: UInt8(aDecoder.decodeInt32ForKey(MPCMessageKey.SnakeDirection.rawValue)))!
        self.type = SnakeType(rawValue: UInt(aDecoder.decodeInt32ForKey(MPCMessageKey.SnakeType.rawValue)))!

        super.init()
    }

}