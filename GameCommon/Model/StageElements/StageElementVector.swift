//
//  StageElementVector.swift
//  GameSwift
//
//  Created by eandrade21 on 6/1/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class StageElementVector: NSObject, NSCoding {

    var locationsSerializable = [StageLocationSerializable]()
    var direction: Direction?
    var locations: [StageLocation] {
        return locationsSerializable.map() {
            StageLocation(x: Int($0.x), y: Int($0.y))
        }
    }

    init (locations: [StageLocation], direction: Direction?) {

        self.locationsSerializable = locations.map() {
            StageLocationSerializable(location: $0)
        }
        self.direction = direction

        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(locationsSerializable, forKey: MPCMessageKey.ElementLocations.rawValue)

        if let _ = direction {
            aCoder.encodeInt32(Int32(direction!.rawValue), forKey: MPCMessageKey.ElementDirection.rawValue)
        }
    }

    public required init(coder aDecoder: NSCoder) {

        self.locationsSerializable = aDecoder.decodeObjectForKey(MPCMessageKey.ElementLocations.rawValue) as [StageLocationSerializable]

        let direction = aDecoder.decodeInt32ForKey(MPCMessageKey.ElementDirection.rawValue)
        if direction != 0 { self.direction = Direction(rawValue: UInt8(direction)) }

        super.init()
    }
}
