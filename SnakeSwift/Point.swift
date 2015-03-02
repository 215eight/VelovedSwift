//
//  Point.swift
//  SnakeSwift
//
//  Created by eandrade21 on 2/4/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

struct Point:Equatable{
    var x : Int = 0
    var y : Int = 0

}

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
