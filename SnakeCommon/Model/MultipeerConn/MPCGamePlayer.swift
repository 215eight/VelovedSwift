//
//  MPCGamePlayer.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public enum MPCGamePlayerStatus: String  {
    case Undefined = "Undefined"
    case Connecting = "Connecting"
    case Connected = "Connected"
    case NotConnected = "NotConnected"
}

public class MPCGamePlayer: NSObject {

    public var peerID: MCPeerID
    public var uniqueID: NSUUID

    public convenience init(delegate: MPCGamePlayerDelegate) {
        self.init(name: delegate.name, uniqueID: delegate.uniqueID.UUIDString)
    }

    init(name: String, uniqueID: String) {
        self.peerID = MCPeerID(displayName: name)
        self.uniqueID = NSUUID(UUIDString: uniqueID)!
        super.init()
    }

}
