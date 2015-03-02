//
//  Stage.swift
//  SnakeSwift
//
//  Created by eandrade21 on 2/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class Stage{
    
    //Variables
    var hasWalls : Bool
    var height, width : Int
    var appleLocation = Point(x:0, y:0)
    var borderWidth = 1
    
    //Methods
    init(height: Int, width: Int, hasWalls : Bool) {
        self.height = height
        self.width = width
        self.hasWalls = hasWalls
        self.appleLocation = randomPoint()
    }
    
    func generateRandomApple(){
        appleLocation = randomPoint()
    }
    
    func randomPoint() -> Point {
        if hasWalls{
            return Point(x: Int(borderWidth + arc4random_uniform(UInt32(width - (borderWidth * 2)))),
                         y: Int(borderWidth + arc4random_uniform(UInt32(height - (borderWidth * 2)))))
        }else{
            return Point(x: Int(arc4random_uniform(UInt32(width))),
                         y: Int(arc4random_uniform(UInt32(height))))
        }
    }
}
