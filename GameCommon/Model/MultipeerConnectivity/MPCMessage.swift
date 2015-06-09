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
    case PlayerDidSecureTarget
    case InitTarget
    case TargetWasSecured
    case TargetDidUpdateLocation
    case GameDidEnd
    case PeerIsConnecting
    case PeerDidConnect
    case PeerDidNotConnect
    case PlayerQuitInitialization
    case PlayerQuitGame

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
        case .PlayerDidSecureTarget:
            return "Player Did Secure Target"
        case .InitTarget:
            return "Init Target"
        case .TargetWasSecured:
            return "Target Was Secured"
        case .TargetDidUpdateLocation:
            return "Target Did Update Location"
        case .GameDidEnd:
            return "Game Did End"
        case .PeerIsConnecting:
            return "Peer Is Connecting"
        case .PeerDidConnect:
            return "Peer Did Connect"
        case .PeerDidNotConnect:
            return "Peer Did Not Connect"
        case .PlayerQuitInitialization:
            return "Player Quit Initialization"
        case .PlayerQuitGame:
            return "Player Quit Game"
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
    case TargetConfig = "trgCfgK"

    // Stage Element
    case ElementLocations = "locK"
    case ElementDirection = "dirK"

    // Stage Location
    case LocationX = "locXK"
    case LocationY = "locY"

    // Player
    case PlayerType = "typK"

    // Target
    case TargetMode = "trgModK"

    // PeerID
    case PeerID = "peeridK"
}

protocol GameMessages {
    func testMessage(message: MPCMessage)
    func initPlayer(message: MPCMessage)
    func didShowGameViewController(message: MPCMessage)
    func scheduleGame(message: MPCMessage)
    func didScheduleGame(message: MPCMessage)
    func elementDidMoveMessage(message: MPCMessage)
    func playerDidCrash(message: MPCMessage)
    func playerDidChangeDirection(message: MPCMessage)
    func playerDidSecureTarget(message: MPCMessage)
    func initTarget(message: MPCMessage)
    func targetWasSecured(message: MPCMessage)
    func targetDidUpdateLocation(message: MPCMessage)
    func gameDidEnd(message: MPCMessage)
    func peerIsConnecting(message: MPCMessage)
    func peerDidConnect(message: MPCMessage)
    func peerDidNotConnect(message: MPCMessage)
    func playerQuitGame(message: MPCMessage)
    func playerQuitInitialization(message: MPCMessage)
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
        case .ShowGameViewController:
            return {(delegate: GameMessages) in assertionFailure("This message should not be  forward to any status")}
        case .DidShowGameViewController:
            return {(delegate: GameMessages) in delegate.didShowGameViewController(message)}
        case .InitPlayer:
            return {(delegate: GameMessages) in delegate.initPlayer(message)}
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
        case .PlayerDidSecureTarget:
            return {(delegate: GameMessages) in delegate.playerDidSecureTarget(message)}
        case .InitTarget:
            return {(delegate: GameMessages) in delegate.initTarget(message)}
        case .TargetDidUpdateLocation:
            return {(delegate: GameMessages) in delegate.targetDidUpdateLocation(message)}
        case .TargetWasSecured:
            return {(delegate: GameMessages) in delegate.targetWasSecured(message)}
        case .PeerIsConnecting:
            return {(delegate: GameMessages) in delegate.peerIsConnecting(message)}
        case .PeerDidConnect:
            return {(delegate: GameMessages) in delegate.peerDidConnect(message)}
        case .PeerDidNotConnect:
            return {(delegate: GameMessages) in delegate.peerDidNotConnect(message)}
        case .PlayerQuitInitialization:
            return {(delegate: GameMessages) in delegate.playerQuitInitialization(message)}
        case .PlayerQuitGame:
            return {(delegate: GameMessages) in delegate.playerQuitGame(message)}
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
        return MPCMessage(event: MPCMessageEvent.ElementDidMove, body: body)
    }

    public class func getPlayerDidCrashMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.PlayerDidCrash, body: nil)
    }

    public class func getPlayerDidChangeDirectionMessage(newElementVector: StageElementVector) -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.ElementVector.rawValue : newElementVector]
        return MPCMessage(event: MPCMessageEvent.PlayerDidChangeDirection, body: body)
    }

    public class func getPlayerDidSecureTargetMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.PlayerDidSecureTarget, body: nil)
    }

    public class func getInitTargetMessage(targetConfig: TargetConfiguration) -> MPCMessage {
        let body : [String : AnyObject] = [MPCMessageKey.TargetConfig.rawValue : targetConfig]
        return MPCMessage(event: MPCMessageEvent.InitTarget, body: body)
    }

    public class func getTargetWasSecuredMessage(newElementVector: StageElementVector) -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.ElementVector.rawValue : newElementVector]
        return MPCMessage(event: MPCMessageEvent.TargetWasSecured, body: body)
    }

    public class func getTargetDidUpdateLocationMessage(newElementVector: StageElementVector) -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.ElementVector.rawValue : newElementVector]
        return MPCMessage(event: MPCMessageEvent.TargetDidUpdateLocation, body: body)
    }

    public class func getGameDidEndMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.GameDidEnd, body: nil)
    }

    class func getPeerIsConnectingMessage(peer: MCPeerID) -> MPCMessage {
        let body : [String : AnyObject] = [MPCMessageKey.PeerID.rawValue : peer]
        return MPCMessage(event: MPCMessageEvent.PeerIsConnecting, body: body)
    }

    class func getPeerDidConnectMessage(peer: MCPeerID) -> MPCMessage {
        let body : [String : AnyObject] = [MPCMessageKey.PeerID.rawValue : peer]
        return MPCMessage(event: MPCMessageEvent.PeerDidConnect, body: body)
    }

    class func getPeerDidNotConnectMessage(peer: MCPeerID) -> MPCMessage {
        let body : [String : AnyObject] = [MPCMessageKey.PeerID.rawValue : peer]
        return MPCMessage(event: MPCMessageEvent.PeerDidNotConnect, body: body)
    }

    class func getPlayerQuitGameMessage(message: MPCMessage) -> MPCMessage? {
        if message.event == MPCMessageEvent.PeerDidNotConnect {
            if let body = message.body {
                return MPCMessage(event: MPCMessageEvent.PlayerQuitGame, body: body)
            }
        } else {
            assertionFailure("Invalid message used as an argument")
        }
        return nil
    }

    class func getPlayerQuitInitializationMessage(message: MPCMessage) -> MPCMessage? {
        if message.event == MPCMessageEvent.PeerDidNotConnect {
            if let body = message.body {
                return MPCMessage(event: MPCMessageEvent.PlayerQuitInitialization, body: body)
            }
        }else {
            assertionFailure("Invalid message used as an argument")
        }
        return nil
    }
}