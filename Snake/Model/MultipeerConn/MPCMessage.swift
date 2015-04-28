//
//  MPCMessage.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/24/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation


enum MPCMessageEvent: String {
    case TestMsg = "testMsgEvent"
    case StartGame = "startGameEvent"
    case EndGame = "endGame"
}

enum MPCMessageKey: String {
    case Sender = "senderKey"
    case Receiver = "receiverKey"
    case TestMsgBody = "testMsgBodyKey"
    case Event = "eventKey"
    case Body = "bodyKey"
    case GameStartTime = "gameStartTimeKey"
    case GameDelay = "gameDelayKey"
}

class MPCMessage: NSObject, NSCoding {

    var event: MPCMessageEvent
    var sender: String
    var body: [MPCMessageKey : String]

    init(event: MPCMessageEvent, body: [MPCMessageKey : String]) {
        self.event = event
        self.sender = MPCController.sharedMPCController.peerID.displayName
        self.body = body
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(event.rawValue, forKey: MPCMessageKey.Event.rawValue)
        aCoder.encodeObject(sender, forKey: MPCMessageKey.Sender.rawValue)

        var tempBody = [String: String]()
        for (key, value) in body {
            tempBody[key.rawValue] = value
        }
        aCoder.encodeObject(tempBody, forKey: MPCMessageKey.Body.rawValue)
    }

    required init(coder aDecoder: NSCoder) {
        event = MPCMessageEvent(rawValue: aDecoder.decodeObjectForKey(MPCMessageKey.Event.rawValue) as String)!
        sender = aDecoder.decodeObjectForKey(MPCMessageKey.Sender.rawValue) as String
        let tempBody = aDecoder.decodeObjectForKey(MPCMessageKey.Body.rawValue) as [ String : String]

        body = [MPCMessageKey : String]()
        for (key, value) in tempBody {
            let _key = MPCMessageKey(rawValue: key)!
            body[_key] = value
        }

        super.init()
    }

    class func getStartGameMessage(startTime: String, delay: String) -> MPCMessage {

        let body = [MPCMessageKey.GameStartTime: startTime,
                    MPCMessageKey.GameDelay: delay]

        return MPCMessage(event: MPCMessageEvent.StartGame, body: body)
    }

    class func getTestMessage(body: String) -> MPCMessage {
        let body = [MPCMessageKey.TestMsgBody: body]

        return MPCMessage(event: MPCMessageEvent.TestMsg, body: body)
    }

    func serialize() -> NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }

    class func deserialize(data: NSData) -> MPCMessage? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? MPCMessage
    }

}