//
//  SnakeMock.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/15/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class SnakeMock: Snake {

    override var speed: NSTimeInterval {
        get {
            return 0
        }
        set {
            super.speed = newValue
        }
    }
    
}