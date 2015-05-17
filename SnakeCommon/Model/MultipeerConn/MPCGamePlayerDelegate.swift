//
//  MPCGamePlayerUUUID.swift
//  MPCTests
//
//  Created by eandrade21 on 5/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

private let uniqueIDListKey = "uniqueIDListKey"
private let uniqueIDKey = "uniqueIDKey"
private let uniqueIDListFileName = "SnakeGameUniqueIDList"

protocol MPCGamePlayerDelegate {
    var uniqueID: NSUUID! { get }
    var name: String { get }
}

public class MPCGamePlayer_iOS: NSObject, MPCGamePlayerDelegate {

    public var uniqueID: NSUUID!
    public var name = "Foo"

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


public class MPCGamePlayer_OSX: NSObject, MPCGamePlayerDelegate {

    public var uniqueID: NSUUID!
    public var name = "Foo"

    private enum UniqueIDStatus: Int {
        case Free = 0
        case Taken = 1
    }

    override public init() {
        super.init()
        uniqueID = initUniqueID()
    }

    func initUniqueID() -> NSUUID {
        var uniqueID: NSUUID?
        var _uniqueIDList = MPCGamePlayer_OSX.uniqueIDList()

        if _uniqueIDList.isEmpty {
            uniqueID = NSUUID()
            _uniqueIDList[uniqueID!] = UniqueIDStatus.Taken.rawValue
        } else {
            for (id, status) in _uniqueIDList {
                if status == UniqueIDStatus.Free.rawValue {
                    _uniqueIDList[id] = UniqueIDStatus.Taken.rawValue
                    uniqueID = id
                    break
                }
            }

            if uniqueID == nil {
                uniqueID = NSUUID()
                _uniqueIDList[uniqueID!] = UniqueIDStatus.Taken.rawValue
            }
        }

        MPCGamePlayer_OSX.saveUniqueIDList(_uniqueIDList)

        return uniqueID!
    }

    deinit {
        var _uniqueIDList = MPCGamePlayer_OSX.uniqueIDList()
        _uniqueIDList[uniqueID] = UniqueIDStatus.Free.rawValue
        MPCGamePlayer_OSX.saveUniqueIDList(_uniqueIDList)
    }
}

public extension MPCGamePlayer_OSX {
    class func uniqueIDListURL() -> NSURL? {
        let applicationURLs = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.ApplicationDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        var applicationURL = applicationURLs.first as? NSURL
        var uniqueIDListURL = applicationURL?.URLByAppendingPathComponent(uniqueIDListFileName)
        return uniqueIDListURL
    }

    class func uniqueIDList() -> [NSUUID : Int] {
        if let uniqueIDListPath = uniqueIDListURL()?.path {
            if NSFileManager.defaultManager().fileExistsAtPath(uniqueIDListPath) {
                if let uniqueIDListData = NSData(contentsOfFile: uniqueIDListPath) {
                    return NSKeyedUnarchiver.unarchiveObjectWithData(uniqueIDListData) as [NSUUID : Int]
                }
            }
        }

        var uniqueIDList = [NSUUID : Int]()
        self.saveUniqueIDList(uniqueIDList)
        return uniqueIDList
    }

    class func saveUniqueIDList(list: [NSUUID : Int]) -> Bool {
        let uniqueIDListData = NSKeyedArchiver.archivedDataWithRootObject(list)

        var error: NSError?
        if let listURL = self.uniqueIDListURL() {
            var error: NSError?
            let success = uniqueIDListData.writeToURL(listURL,
                options: NSDataWritingOptions.AtomicWrite,
                error: &error)

            if !success {
                println("ERROR: Unable to save unique ID list to path \(listURL.path)")
            }

            return success

        } else {
            println("ERROR: Invalid URL to save unique ID list")
            return false
        }
    }

    public class func deleteUniqueIDList() {
        if let listURL = self.uniqueIDListURL() {
            var error: NSError?
            NSFileManager.defaultManager().removeItemAtURL(listURL, error: &error)
        }
    }
}