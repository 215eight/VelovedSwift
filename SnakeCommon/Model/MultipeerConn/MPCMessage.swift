//
//  MPCMessage.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/24/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation


public enum MPCMessageEvent: String {
    case TestMsg = "testMsgEvent"
    case SetUpGame = "setUpGameEvent"
    case ScheduleGame = "scheduleGameEvent"
    case EndGame = "endGameEvent"
}

public enum MPCMessageKey: String {
    case Sender = "senderKey"
    case Receiver = "receiverKey"
    case TestMsgBody = "testMsgBodyKey"
    case Event = "eventKey"
    case Body = "bodyKey"
    case GameStartTime = "gameStartTimeKey"
    case GameDelay = "gameDelayKey"
}

public class MPCMessage: NSObject, NSCoding {

    public var event: MPCMessageEvent
    public var sender: String
    public var body: [MPCMessageKey : String]?

    init(event: MPCMessageEvent, body: [MPCMessageKey : String]?) {
        self.event = event
        self.sender = MPCController.sharedMPCController.peerID.displayName
        self.body = body

        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(event.rawValue, forKey: MPCMessageKey.Event.rawValue)
        aCoder.encodeObject(sender, forKey: MPCMessageKey.Sender.rawValue)

        if let _body = body {
            var tempBody = [String : String]()
            for (key, value) in _body {
                tempBody[key.rawValue] = value
            }
            aCoder.encodeObject(tempBody, forKey: MPCMessageKey.Body.rawValue)
        }

    }

    required public init(coder aDecoder: NSCoder) {
        self.event = MPCMessageEvent(rawValue: aDecoder.decodeObjectForKey(MPCMessageKey.Event.rawValue) as String)!

        self.sender = aDecoder.decodeObjectForKey(MPCMessageKey.Sender.rawValue) as String

        if let tempBody = aDecoder.decodeObjectForKey(MPCMessageKey.Body.rawValue) as? [ String : String] {
            self.body = [MPCMessageKey : String]()
            for (key, value) in tempBody {
                let _key = MPCMessageKey(rawValue: key)!
                self.body![_key] = value
            }
        }

        super.init()
    }

    func serialize() -> NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }

    class func deserialize(data: NSData) -> MPCMessage? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? MPCMessage
    }
}

extension MPCMessage {

    public class func getSetUpGameMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.SetUpGame, body: nil)
    }

    public class func getScheduleGameMessage(startTime: String)  -> MPCMessage {

        let body = [MPCMessageKey.GameStartTime: startTime]

        return MPCMessage(event: MPCMessageEvent.ScheduleGame, body: body)
    }

    public class func getTestMessage(body: String) -> MPCMessage {
        let body = [MPCMessageKey.TestMsgBody: body]

        return MPCMessage(event: MPCMessageEvent.TestMsg, body: body)
    }
}