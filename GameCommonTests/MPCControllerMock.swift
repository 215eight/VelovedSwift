//
//  MPCControllerMock.swift
//  GameSwift
//
//  Created by eandrade21 on 5/29/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MPCControllerMock: MPCController {

    var connectedPeers: [MCPeerID]!

    override func getConnectedPeers() -> [MCPeerID] {
        return connectedPeers
    }
}