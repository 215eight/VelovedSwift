//
//  MPCGamePlayerMock.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class MPCGamePlayerDelegateMock: NSObject, MPCGamePlayerDelegate {

    var uniqueID: NSUUID! {
        return NSUUID()
    }

    var name: String! {
        return "MPCGamePlayerMock"
    }

}