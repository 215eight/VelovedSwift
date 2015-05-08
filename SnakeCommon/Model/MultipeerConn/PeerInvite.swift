//
//  PeerInvite.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/22/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import MultipeerConnectivity

public enum PeerInviteStatus: Printable {
    case Pending
    case Connecting
    case Connected
    case NotConnected

    public var description: String {
        switch self {
        case .Pending:
            return "Pending"
        case .Connecting:
            return "Connecting"
        case .Connected:
            return "Connected"
        case .NotConnected:
            return "Not Connected"
        }
    }
}

public class PeerInvite: NSObject {

    typealias PeerInviteHandler = ((Bool, MCSession!) -> Void)!

    public var peerID: MCPeerID
    public var status: PeerInviteStatus

    init(peerID: MCPeerID, status: PeerInviteStatus) {
        self.peerID = peerID
        self.status = status

        super.init()
    }

}