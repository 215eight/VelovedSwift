//
//  TargetConfiguration.swift
//  GameSwift
//
//  Created by eandrade21 on 5/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class TargetConfiguration: NSObject, NSCoding {

    private var locationsSerializable = [StageLocationSerializable]()

    public var locations: [StageLocation] {
        return locationsSerializable.map() {
            StageLocation(x: Int($0.x), y: Int($0.y))
        }
    }

    init(locations: [StageLocation]) {
        locationsSerializable = locations.map() {
            StageLocationSerializable(location: $0)
        }
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(locationsSerializable, forKey: MPCMessageKey.Locations.rawValue)
    }

    required public init(coder aDecoder: NSCoder) {

        self.locationsSerializable = aDecoder.decodeObjectForKey(MPCMessageKey.Locations.rawValue) as [StageLocationSerializable]

        super.init()
    }
}