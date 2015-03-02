//
//  Snake.swift
//  SnakeSwift
//
//  Created by eandrade21 on 2/3/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

enum Direction : UInt{
    case up
    case down
    case right
    case left
    
    static func randomDirection() -> Direction {
        var maxValue : UInt = 0
        while let _ = Direction(rawValue: ++maxValue) {}
        let rand = arc4random_uniform(UInt32(maxValue))
        return Direction(rawValue: UInt(rand))!
    }
}

class Snake {
    
    //Properties
    var body : [Point] = []
    let initSize = 4
    var direction = Direction.down
    var lastTailPoint = Point(x:0, y:0)
    var speed : UInt32 = 125000
    
    //Designated Init
    init(originy: Int, originx : Int, height:Int, width:Int) {
        
        //Determine origin and direction
        var origin = randomOriginWithinBoundaries(originy, originx:originx, height:height, width:width)
        direction = Direction.randomDirection()
        buildSnakeBody(origin)
        
    }
    
    
    //Methods
    func randomOriginWithinBoundaries(originy: Int, originx : Int, height:Int, width:Int) -> Point{
        
        return Point(x: originx + Int(arc4random_uniform(UInt32(width))),
                     y: originy + Int(arc4random_uniform(UInt32(height))))
    }
    
    func buildSnakeBody(origin:Point){
        
        body.append(origin)
        
        for index in 1 ... initSize{
            
            switch direction{
            case .down:
                if(index != initSize) {
                    body.append(Point(x:origin.x, y:origin.y-index))
                }else{
                    lastTailPoint = Point(x:origin.x, y:origin.y-index)
                }
            case .up:
                if(index != initSize) {
                    body.append(Point(x:origin.x, y:origin.y+index))
                }else{
                    lastTailPoint = Point(x:origin.x, y:origin.y+index)
                }
                
            case .left:
                if(index != initSize) {
                    body.append(Point(x:origin.x+index, y:origin.y))
                }else{
                    lastTailPoint = Point(x:origin.x+index, y:origin.y)
                }
                
            case .right:
                if(index != initSize) {
                    body.append(Point(x:origin.x-index, y:origin.y))
                }else{
                    lastTailPoint = Point(x:origin.x-index, y:origin.y)
                }
            }
        }
        

    }
    
    func move(stage: Stage) {
        
        precondition(body.count >= 2, "Snake should be at lest 2 units long")
        
        //Save the lastTailPoint
        if let lastPoint = body.last {
            lastTailPoint = lastPoint
        }
        
        //Swift all positions, except the origin, by one starting from the last position
        for index in reverse(1 ..< body.count) {
            body[index] = body[index-1]
        }
        
        //Generate new origin
        if stage.hasWalls{
            switch direction {
            case .up:
                body[0] = Point(x:body[0].x, y:body[0].y-1)
            case .down:
                body[0] = Point(x:body[0].x, y:body[0].y+1)
            case .right:
                body[0] = Point(x:body[0].x+1, y:body[0].y)
            case .left:
                body[0] = Point(x:body[0].x-1, y:body[0].y)
            }
        }else{
            var newCoordinate : Int
            
            switch direction {
            case .up:
                (body[0].y-1 < 0) ? (newCoordinate = stage.height-1) : (newCoordinate = body[0].y-1)
                body[0] = Point(x: body[0].x, y: newCoordinate)
            case .down:
                (body[0].y+1 > stage.height-1) ? (newCoordinate = 0) : (newCoordinate = body[0].y+1)
                body[0] = Point(x: body[0].x, y: newCoordinate)
            case .right:
                (body[0].x+1 > stage.width-1) ? (newCoordinate = 0) : (newCoordinate = body[0].x+1)
                body[0] = Point(x: newCoordinate, y: body[0].y)
            case .left:
                (body[0].x-1 < 0) ? (newCoordinate = stage.width-1) : (newCoordinate = body[0].x-1)
                body[0] = Point(x: newCoordinate, y: body[0].y)
            }
        }
    }
    
    func grow() {
        body.append(lastTailPoint)
        speed = speed - 5000
    }
}