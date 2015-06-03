//
//  MPCMessage.swift
//  GameSwift
//
//  Created by eandrade21 on 4/24/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public enum MPCMessageEvent: Int32, Printable {
    case TestMsg
    case ShowGameViewController
    case DidShowGameViewController
    case InitPlayer
    case ScheduleGame
    case DidScheduleGame
    case ElementDidMove
    case PlayerDidCrash
    case PlayerDidChangeDirection
    case GameDidEnd

    public var description: String {
        switch self {
        case .TestMsg:
            return "Test Message"
        case .ShowGameViewController:
            return "Show Game View Controller"
        case .DidShowGameViewController:
            return "Did Show Game View Controller"
        case .InitPlayer:
            return "Init Player"
        case .ScheduleGame:
            return "Schedule Game"
        case .DidScheduleGame:
            return "Did Schedule Game"
        case .ElementDidMove:
            return "Element Did Move"
        case .PlayerDidCrash:
            return "Player Did Crash"
        case .PlayerDidChangeDirection:
            return "Player Did Change Direction"
        case .GameDidEnd:
            return "Game Did End"
        }
    }

}

public enum MPCMessageKey: String {
    case Sender = "sndK"
    case Receiver = "rxrK"
    case TestMsgBody = "tstMsgBdyK"
    case Event = "evtK"
    case Body = "bdyK"
    case GameStartDate = "gamStrDatK"
    case ElementVector = "elmVctK"
    case PlayerConfig = "plyCfgK"

    // Stage Element
    case ElementLocations = "locK"
    case ElementDirection = "dirK"

    // Stage Location
    case LocationX = "locXK"
    case LocationY = "locY"

    // Player
    case PlayerType = "typK"

}

protocol GameMessages {
    func testMessage(message: MPCMessage)
    func initPlayerMessage(message: MPCMessage)
    func didShowGameViewController(message: MPCMessage)
    func scheduleGame(message: MPCMessage)
    func didScheduleGame(message: MPCMessage)
    func elementDidMoveMessage(message: MPCMessage)
    func playerDidCrash(message: MPCMessage)
    func playerDidChangeDirection(message: MPCMessage)
    func gameDidEnd(message: MPCMessage)
}

public class MPCMessage: NSObject, NSCoding, Printable {

    public var event: MPCMessageEvent
    public var sender: MCPeerID
    public var body: [String : AnyObject]?

    override public var description: String {
        return "Message Event: \(event) - From: \(sender.displayName)"
    }

    init(event: MPCMessageEvent, body: [String : AnyObject]?) {
        self.event = event
        self.sender = MPCController.sharedMPCController.peerID
        self.body = body

        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt32(event.rawValue, forKey: MPCMessageKey.Event.rawValue)
        aCoder.encodeObject(sender, forKey: MPCMessageKey.Sender.rawValue)

        if let _body = body {
            aCoder.encodeObject(_body, forKey: MPCMessageKey.Body.rawValue)
        }

    }

    required public init(coder aDecoder: NSCoder) {
        self.event = MPCMessageEvent(rawValue: aDecoder.decodeInt32ForKey(MPCMessageKey.Event.rawValue))!
        self.sender = aDecoder.decodeObjectForKey(MPCMessageKey.Sender.rawValue) as MCPeerID

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
         case .DidShowGameViewController:
            return {(delegate: GameMessages) in delegate.didShowGameViewController(message)}
        case .InitPlayer:
            return {(delegate: GameMessages) in delegate.initPlayerMessage(message)}
        case .ScheduleGame:
            return {(delegate: GameMessages) in delegate.scheduleGame(message)}
        case .DidScheduleGame:
            return {(delegate: GameMessages) in delegate.didScheduleGame(message)}
        case .ElementDidMove:
            return {(delegate: GameMessages) in delegate.elementDidMoveMessage(message)}
        case .PlayerDidCrash:
            return {(delegate: GameMessages) in delegate.playerDidCrash(message)}
        case .GameDidEnd:
            return {(delegate: GameMessages) in delegate.gameDidEnd(message)}
        case .PlayerDidChangeDirection:
            return {(delegate: GameMessages) in delegate.playerDidChangeDirection(message)}
        default:
            return {(delegate: GameMessages) in assertionFailure("Message has unknown handler")}
        }
    }
}

extension MPCMessage {

    public class func getTestMessage(body: String) -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.TestMsgBody.rawValue : body]
        return MPCMessage(event: MPCMessageEvent.TestMsg, body: body)
    }

    public class func getShowGameViewControllerMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.ShowGameViewController, body: nil)
    }

    public class func getDidShowGameViewControllerMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.DidShowGameViewController, body: nil)
    }
    public class func getInitPlayerMessage(playerConfig: PlayerConfiguration) -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.PlayerConfig.rawValue : playerConfig]
        return MPCMessage(event: MPCMessageEvent.InitPlayer, body: body)
    }

    public class func getScheduleGameMessage(gameStartDate: String)  -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.GameStartDate.rawValue : gameStartDate]
        return MPCMessage(event: MPCMessageEvent.ScheduleGame, body: body)
    }

    public class func getDidScheduleGameMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.DidScheduleGame, body: nil)
    }

    public class func getElementDidMoveMessage(elementVector: StageElementVector) -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.ElementVector.rawValue : elementVector]
        return MPCMessage(event: MPCMessageEvent.ElementDidMove, body: nil)
    }

    public class func getPlayerDidCrashMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.PlayerDidCrash, body: nil)
    }

    public class func getPlayerDidChangeDirectionMessage(newElementVector: StageElementVector) -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.ElementVector.rawValue : newElementVector]
        return MPCMessage(event: MPCMessageEvent.PlayerDidChangeDirection, body: body)
    }

    public class func getGameDidEndMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.GameDidEnd, body: nil)
    }
}