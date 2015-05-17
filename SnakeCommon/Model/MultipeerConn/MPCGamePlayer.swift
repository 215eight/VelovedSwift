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

    private var delegate: MPCGamePlayerDelegate
    public var peerID: MCPeerID
    public var uniqueID: NSUUID

    public init(delegate: MPCGamePlayerDelegate) {
        self.delegate = delegate
        self.peerID = MCPeerID(displayName: delegate.name)
        self.uniqueID = delegate.uniqueID
        super.init()
    }

}
