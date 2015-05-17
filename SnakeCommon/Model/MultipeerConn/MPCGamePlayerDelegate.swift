//
//  MPCGamePlayerUUUID.swift
//  MPCTests
//
//  Created by eandrade21 on 5/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation



public protocol MPCGamePlayerDelegate {
    var uniqueID: NSUUID! { get }
    var name: String! { get }
}

