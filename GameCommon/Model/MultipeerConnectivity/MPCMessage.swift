//
//  MPCMessage.swift
//  GameSwift
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
    case GameStartDate = "gameStartDate"

    // Locatable
    case Locations = "locationsKey"
    case LocationX = "locationXKey"
    case LocationY = "locationYKey"

    // Player
    case PlayerDirection = "directionKey"
    case PlayerType = "typeKey"

}

protocol GameMessages {
    func testMessage(message: MPCMessage)
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

    class func getMessageHandler(message: MPCMessage) -> (GameMessages) -> Void {
        switch message.event {
        case .TestMsg:
            return {(delegate: GameMessages) in delegate.testMessage(message)}
        default:
            return {(delegate: GameMessages) in assertionFailure("Message has unknown handler")}
        }
    }
}

extension MPCMessage {

    public class func getSetUpGameMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.SetUpGame, body: nil)
    }

    public class func getScheduleGameMessage(gameStartDate: String)  -> MPCMessage {

        let body: [String : AnyObject] = [MPCMessageKey.GameStartDate.rawValue : gameStartDate]

        return MPCMessage(event: MPCMessageEvent.ScheduleGame, body: body)
    }

    public class func getTestMessage(body: String) -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.TestMsgBody.rawValue : body]

        return MPCMessage(event: MPCMessageEvent.TestMsg, body: body)
    }
}