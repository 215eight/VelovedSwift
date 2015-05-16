//
//  MPCGamePlayerUUUID.swift
//  MPCTests
//
//  Created by eandrade21 on 5/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class MPCGamePlayerUUID: NSObject {

    private var delegate: MPCGamePlayerUUIDDelegate

    var uniqueID: NSUUID {
        return delegate.uniqueID
    }

    override init() {
        #if os(iOS)
            delegate = MPCGamePlayerUUID_iOS()
        #elseif os(OSX)
            delegate = MPCGamePlayerUUID_OSX()
        #endif
        super.init()
    }

}

protocol MPCGamePlayerUUIDDelegate {
    var uniqueID: NSUUID! { get }
}

private let uniqueIDListKey = "uniqueIDListKey"
private let uniqueIDKey = "uniqueIDKey"

public class MPCGamePlayerUUID_iOS: NSObject, MPCGamePlayerUUIDDelegate {

    public var uniqueID: NSUUID!

    override public init() {
        super.init()
        uniqueID = initUniqueID()
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
}

class MPCGamePlayerUUID_OSX: NSObject, MPCGamePlayerUUIDDelegate {

    var uniqueID: NSUUID!

    deinit {

    }
}
