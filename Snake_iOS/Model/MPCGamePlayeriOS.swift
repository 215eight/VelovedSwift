//
//  MPCGamePlayeriOS.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import UIKit
import SnakeCommon

public class MPCGamePlayeriOS: NSObject, MPCGamePlayerDelegate {

    private let uniqueIDKey = "uniqueKey"
    public var uniqueID: NSUUID!
    public var name: String!

    override public init() {
        super.init()
        uniqueID = initUniqueID()
        name = initName()
    }

    func initUniqueID() -> NSUUID {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let persistedUniqueIDStr = defaults.objectForKey(uniqueIDKey) as? String {
            return NSUUID(UUIDString: persistedUniqueIDStr)!
        } else {
            let newUniqueID = NSUUID()
            defaults.setObject(newUniqueID.UUIDString, forKey: uniqueIDKey)
            defaults.synchronize()
            return newUniqueID
        }
    }

    func initName() -> String {
        return UIDevice.currentDevice().name
    }
    
}