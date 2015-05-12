//
//  AppleLocal.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

class AppleLocal: Apple {

    override func updateLocation() {
        super.updateLocation()

        let appleDidChangeLocationMsg = MPCMessage.getAppleDidChangeLocationMessage(self.locations)
        MPCController.sharedMPCController.sendMessage(appleDidChangeLocationMsg)
    }
    
}