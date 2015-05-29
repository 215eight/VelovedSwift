//
//  MPCControllerTests.swift
//  GameSwift
//
//  Created by eandrade21 on 5/29/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import MultipeerConnectivity

class MPCControllerTests: XCTestCase {

    func testControllerCalculatesPrecedence() {

        let controller = MPCController()
        XCTAssertTrue(controller.precedence == 0, "Only one connected peer")
    }

    func testControllerCalculatesPrecedenceWithConnectedPeers() {
        var controller0 = MPCControllerMock()
        var controller1 = MPCControllerMock()
        var controller2 = MPCControllerMock()
        var controller3 = MPCControllerMock()

        var peer0 = controller0.peerID
        var peer1 = controller1.peerID
        var peer2 = controller2.peerID
        var peer3 = controller3.peerID

        controller0.connectedPeers = [peer1, peer2, peer3]
        controller1.connectedPeers = [peer0, peer2, peer3]
        controller2.connectedPeers = [peer0, peer1, peer3]
        controller3.connectedPeers = [peer0, peer1, peer2]

        let precedence0 = controller0.precedence
        let precedence1 = controller1.precedence
        let precedence2 = controller2.precedence
        let precedence3 = controller3.precedence

        var precedenceArray = [precedence0, precedence1, precedence2, precedence3]
        precedenceArray.sort( {$0 < $1} )

        XCTAssertEqual(precedenceArray[0], 0, "First turn is 0. Also highest precedence")
        XCTAssertEqual(precedenceArray[1], 1, "One unit is added to denote subsequent turns")
        XCTAssertEqual(precedenceArray[2], 2, "Third turn")
        XCTAssertEqual(precedenceArray[3], 3, "Total of turns = connected peers minus 1. Also lowest precedence")
    }
}
