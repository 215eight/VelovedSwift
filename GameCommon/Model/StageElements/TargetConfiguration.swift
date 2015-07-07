//
//  TargetConfiguration.swift
//  VelovedGame
//
//  Created by eandrade21 on 5/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class TargetConfiguration: NSObject, NSCoding {

    private var vector: StageElementVector
    var mode: TargetMode

    var locations: [StageLocation] {
        return vector.locations
    }

    init(locations: [StageLocation], mode: TargetMode) {
        self.vector = StageElementVector(locations: locations, direction: nil)
        self.mode = mode
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(vector, forKey: MPCMessageKey.ElementVector.rawValue)
        aCoder.encodeInt32(Int32(mode.rawValue), forKey: MPCMessageKey.TargetMode.rawValue)
    }

    required public init(coder aDecoder: NSCoder) {

        self.vector = aDecoder.decodeObjectForKey(MPCMessageKey.ElementVector.rawValue) as! StageElementVector
        self.mode = TargetMode(rawValue: UInt8(aDecoder.decodeInt32ForKey(MPCMessageKey.TargetMode.rawValue)))!
        super.init()
    }
}