//
//  MPCGamePlayerOSX.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import SnakeCommon

private let uniqueIDListFileName = "SnakeGameUniqueIDList"

class MPCGamePlayerOSX: NSObject, MPCGamePlayerDelegate {

    var uniqueID: NSUUID!
    var name: String!

    private let uniqueIDListKey = "uniqueIDListKey"
    private let kDefaultHostName = "UnknowHostName"
    private enum UniqueIDStatus: Int {
        case Free = 0
        case Taken = 1
    }

    override init() {
        super.init()
        uniqueID = initUniqueID()
        name = initName()
    }

    func initUniqueID() -> NSUUID {
        var uniqueID: NSUUID?
        var _uniqueIDList = MPCGamePlayerOSX.uniqueIDList()

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

        MPCGamePlayerOSX.saveUniqueIDList(_uniqueIDList)

        return uniqueID!
    }

    func initName() -> String {

        var gamePlayerName: String
        let pid = NSProcessInfo.processInfo().processIdentifier
        #if os(OSX)
            if let hostname = NSHost.currentHost().name {
                gamePlayerName = String(format: "%@-%d", arguments: [hostname, pid])
            } else {
                gamePlayerName = String(format: "%@-%d", arguments: [kDefaultHostName, pid])
            }
        #endif

        return gamePlayerName
    }

    deinit {
        var _uniqueIDList = MPCGamePlayerOSX.uniqueIDList()
        _uniqueIDList[uniqueID] = UniqueIDStatus.Free.rawValue
        MPCGamePlayerOSX.saveUniqueIDList(_uniqueIDList)
    }
}


extension MPCGamePlayerOSX {
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

    class func deleteUniqueIDList() {
        if let listURL = self.uniqueIDListURL() {
            var error: NSError?
            NSFileManager.defaultManager().removeItemAtURL(listURL, error: &error)
        }
    }
}