//
//  PlayerConfiguration.swift
//  GameSwift
//
//  Created by eandrade21 on 5/10/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class PlayerConfiguration: NSObject, NSCoding {

    private var vector: StageElementVector
    var locations: [StageLocation] {
        return vector.locations
    }
    var direction: Direction {
        return vector.direction!
    }
    let type: PlayerType

    init(locations: [StageLocation], direction: Direction, type: PlayerType) {
        self.vector = StageElementVector(locations: locations, direction: direction)
        self.type = type
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(vector, forKey: MPCMessageKey.ElementVector.rawValue)
        aCoder.encodeInt32(Int32(type.rawValue), forKey: MPCMessageKey.PlayerType.rawValue)
    }

    required public init(coder aDecoder: NSCoder) {

        self.vector = aDecoder.decodeObjectForKey(MPCMessageKey.ElementVector.rawValue) as StageElementVector
        self.type = PlayerType(rawValue: UInt(aDecoder.decodeInt32ForKey(MPCMessageKey.PlayerType.rawValue)))!

        super.init()
    }

}