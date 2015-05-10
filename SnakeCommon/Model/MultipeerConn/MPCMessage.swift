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
    case SetUpSnakes = "setUpSnakesEvent"
}

public enum MPCMessageKey: String {
    case Sender = "senderKey"
    case Receiver = "receiverKey"
    case TestMsgBody = "testMsgBodyKey"
    case Event = "eventKey"
    case Body = "bodyKey"
    case GameStartDate = "gameStartDate"

    // Sanke
    case SnakeLocationsX = "locationsXKey"
    case SnakeLocationsY = "locationsYKey"
    case SnakeDirection = "directionKey"
    case SnakeType = "typeKey"
}

public class MPCMessage: NSObject, NSCoding {

    public var event: MPCMessageEvent
    public var sender: String
    public var body: [String : AnyObject]?

    init(event: MPCMessageEvent, body: [String : AnyObject]?) {
        self.event = event
        self.sender = MPCController.sharedMPCController.peerID.displayName
        self.body = body

        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(event.rawValue, forKey: MPCMessageKey.Event.rawValue)
        aCoder.encodeObject(sender, forKey: MPCMessageKey.Sender.rawValue)

        if let _body = body {
            aCoder.encodeObject(_body, forKey: MPCMessageKey.Body.rawValue)
        }

    }

    required public init(coder aDecoder: NSCoder) {
        self.event = MPCMessageEvent(rawValue: aDecoder.decodeObjectForKey(MPCMessageKey.Event.rawValue) as String)!

        self.sender = aDecoder.decodeObjectForKey(MPCMessageKey.Sender.rawValue) as String

        if let body = aDecoder.decodeObjectForKey(MPCMessageKey.Body.rawValue) as? [String : AnyObject] {
            self.body = body
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

    public class func getScheduleGameMessage(gameStartDate: String)  -> MPCMessage {

        let body: [String : AnyObject] = [MPCMessageKey.GameStartDate.rawValue: gameStartDate]

        return MPCMessage(event: MPCMessageEvent.ScheduleGame, body: body)
    }

    public class func getSetUpSnakesMessage(snakeMap: [String : Snake]) -> MPCMessage {

        return MPCMessage(event: MPCMessageEvent.SetUpSnakes, body: snakeMap)
    }

    public class func getTestMessage(body: String) -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.TestMsgBody.rawValue : body]

        return MPCMessage(event: MPCMessageEvent.TestMsg, body: body)
    }
}