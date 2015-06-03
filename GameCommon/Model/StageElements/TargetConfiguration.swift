//
//  TargetConfiguration.swift
//  GameSwift
//
//  Created by eandrade21 on 5/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class TargetConfiguration: NSObject, NSCoding {

    private var vector: StageElementVector

    var locations: [StageLocation] {
        return vector.locations
    }

    init(locations: [StageLocation]) {
        self.vector = StageElementVector(locations: locations, direction: nil)
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(vector, forKey: MPCMessageKey.ElementVector.rawValue)
    }

    required public init(coder aDecoder: NSCoder) {

        self.vector = aDecoder.decodeObjectForKey(MPCMessageKey.ElementVector.rawValue) as StageElementVector
        super.init()
    }
}