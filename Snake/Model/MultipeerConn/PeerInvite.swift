//
//  PeerInvite.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/22/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import MultipeerConnectivity

enum PeerInviteStatus: Printable {
    case Pending
    case Accepted
    case Rejected

    var description: String {
        switch self {
        case .Pending:
            return "Pending"
        case .Accepted:
            return "Accepted"
        case .Rejected:
            return "Rejected"
        }
    }
}

class PeerInvite: NSObject {

    typealias PeerInviteHandler = ((Bool, MCSession!) -> Void)!

    var peerID: MCPeerID
    var status: PeerInviteStatus
    var inviteHandler: PeerInviteHandler

    init(peerID: MCPeerID, status: PeerInviteStatus, inviteHandler: PeerInviteHandler) {
        self.peerID = peerID
        self.status = status
        self.inviteHandler = inviteHandler

        super.init()
    }

}