//
//  AppleConfiguration.swift
//  SnakeSwift
//
//  Created by PartyMan on 5/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class AppleConfiguration: NSObject, NSCoding {
    let locations: [StageLocation]

    init(locations: [StageLocation]) {
        self.locations = locations
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        var _locationsX = [Int]()
        var _locationsY = [Int]()

        for location in locations {
            _locationsX.append(location.x)
            _locationsY.append(location.y)
        }

        aCoder.encodeObject(_locationsX, forKey: MPCMessageKey.LocationsX.rawValue)
        aCoder.encodeObject(_locationsY, forKey: MPCMessageKey.LocationsY.rawValue)
    }

    required public init(coder aDecoder: NSCoder) {
        let _locationsX = aDecoder.decodeObjectForKey(MPCMessageKey.LocationsX.rawValue) as? [Int]
        let _locationsY = aDecoder.decodeObjectForKey(MPCMessageKey.LocationsY.rawValue) as? [Int]
        self.locations = [StageLocation]()

        for index in 0..._locationsX!.count-1 {
            locations.append(StageLocation(x: _locationsX![index], y: _locationsY![index]))
        }

        super.init()
    }
}