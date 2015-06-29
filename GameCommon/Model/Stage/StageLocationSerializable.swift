//
//  StageLocationSerializable.swift
//  VelovedGame
//
//  Created by eandrade21 on 5/12/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class StageLocationSerializable: NSObject, NSCoding {

    public var x: Int32 = 0
    public var y: Int32  = 0

    init(location: StageLocation) {
        self.x = Int32(location.x)
        self.y = Int32(location.y)

        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt32(x, forKey: MPCMessageKey.LocationX.rawValue)
        aCoder.encodeInt32(y, forKey: MPCMessageKey.LocationY.rawValue)
    }

    required public init(coder aDecoder: NSCoder) {
        self.x = aDecoder.decodeInt32ForKey(MPCMessageKey.LocationX.rawValue)
        self.y = aDecoder.decodeInt32ForKey(MPCMessageKey.LocationY.rawValue)
        super.init()
    }
    
}