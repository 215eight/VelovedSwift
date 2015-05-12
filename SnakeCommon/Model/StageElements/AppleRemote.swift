//
//  AppleRemote.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

class AppleRemote: Apple {

    override func animate() {
        // Remote apple does not animate
    }

    override func updateLocation() {
        // Remote apple does not udpdate location by itself
    }

    override func updateLocation(locations: [StageLocation]) {
        if delegate != nil {
            self.locations = locations
            delegate!.elementLocationDidChange(self)
        }
    }
}