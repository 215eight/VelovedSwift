//
//  Snake.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit


enum Direction : UInt{
    case Up
    case Down
    case Right
    case Left
    
    static func randomDirection() -> Direction {
        var maxValue : UInt = 0
        while let _ = Direction(rawValue: ++maxValue) {}
        let rand = arc4random_uniform(UInt32(maxValue))
        return Direction(rawValue: UInt(rand))!
    }
}

class Snake : NSObject {
    
    // MARK: Properties
    var snakeBody = [SnakeBodyPart]()
    var xLowerBound: Float
    var yLowerBound: Float
    var xUpperBound: Float
    var yUpperBound: Float
    var bodySize = 5
    var direction: Direction {
        didSet(oldDirection) {
            // Horizontal direction check
            if (oldDirection == Direction.Up || oldDirection == Direction.Down) && (direction == Direction.Up || direction == Direction.Down) {
                direction = oldDirection
            }
            // Vertical direction check
            else if (oldDirection == Direction.Right || oldDirection == Direction.Left) && (direction == Direction.Right || direction == Direction.Left) {
                direction = oldDirection
            }
        }
    }
    
    var snakeHead : SnakeBodyPart? {
        get{
            if snakeBody.count > 1 {
                return snakeBody[0]
            }
            return nil
        }
    }
    var tailBodyPart = SnakeBodyPart(x: 0, y: 0)
    
    // MARK: Initializers
    
    init(xLowerBound: Float, xUpperBound: Float, yLowerBound: Float, yUpperBound: Float) {
        
        // Bounds limits are used to determine the range of potential locations of a snake body part
        // Since the snake body part location is based on its center, the limits need to be adjusted by 0.5
        // Each potential locaiton is measured by increments of 1.0
        self.xLowerBound = xLowerBound + 0.5
        self.xUpperBound = xUpperBound - 0.5
        self.yLowerBound = yLowerBound + 0.5
        self.yUpperBound = yUpperBound - 0.5
        
        // Get a random direction
        self.direction = Direction.randomDirection()
        
        super.init()
        
        // Get random head origin and build body
        buildBody(randomHeadOrigin())
    }
    
    // MARK: Class Methods
    
    func buildBody(head: SnakeBodyPart) {
    
        
        // Add head to the body
        snakeBody.append(head)
        
        var lastBodyPart = snakeBody.last
        for index in 1 ... bodySize {
            
            var newBodyPart: SnakeBodyPart
            
            switch direction {
            case .Up:
                newBodyPart = SnakeBodyPart(x: lastBodyPart!.locationX, y: lastBodyPart!.locationY + 1)
            case .Down:
                newBodyPart = SnakeBodyPart(x: lastBodyPart!.locationX, y: lastBodyPart!.locationY - 1)
            case .Left:
                newBodyPart = SnakeBodyPart(x: lastBodyPart!.locationX + 1, y: lastBodyPart!.locationY)
            case .Right:
                newBodyPart = SnakeBodyPart(x: lastBodyPart!.locationX - 1, y: lastBodyPart!.locationY)
            }
            
            snakeBody.append(newBodyPart)
            lastBodyPart = newBodyPart
        }
    }
    
    func randomHeadOrigin() -> SnakeBodyPart {
        
        // Create an inset rectangle of the snake size so it isn't too close to the border
        let xLowerBoundInset = xLowerBound + Float(bodySize)
        let xUpperBoundInset = xUpperBound - Float(bodySize)
        let yLowerBoundInset = yLowerBound + Float(bodySize)
        let yUpperBoundInset = yUpperBound + Float(bodySize)
        
        let rangeX = UInt32(xUpperBoundInset) - UInt32(xLowerBoundInset)
        let locationX = xLowerBoundInset + Float(arc4random_uniform(rangeX))
        
        let rangeY = UInt32(yUpperBoundInset) - UInt32(yLowerBoundInset)
        let locationY = yLowerBoundInset + Float(arc4random_uniform(rangeY))
        
        return SnakeBodyPart(x: locationX, y: locationY)
        
    }
    
    // MARK: Instance Methods
    func move(continuos: Bool) {
        
        precondition(snakeBody.count >= 2, "Snake should be at lest 2 units long")
        
        //Save the tail body part
        if let lastPoint = snakeBody.last {
            tailBodyPart = lastPoint
        }
        
        //Swift all positions, except the origin, by one starting from the last position
        for index in reverse(1 ..< snakeBody.count) {
            snakeBody[index] = snakeBody[index-1]
        }
        
        //Generate new origin
        
        if continuos {
            var newLocation : Float
            switch direction {
            case .Up:
                (snakeBody[0].locationY - 1.0 < yLowerBound) ? (newLocation = yUpperBound) : (newLocation = snakeBody[0].locationY - 1)
                snakeBody[0] = SnakeBodyPart(x: snakeBody[0].locationX, y: newLocation)
            case .Down:
                (snakeBody[0].locationY + 1.0 > yUpperBound) ? (newLocation = xLowerBound) : (newLocation = snakeBody[0].locationY + 1)
                snakeBody[0] = SnakeBodyPart(x: snakeBody[0].locationX, y: newLocation)
            case .Right:
                (snakeBody[0].locationX + 1.0 > xUpperBound) ? (newLocation = yLowerBound) : (newLocation = snakeBody[0].locationX + 1)
                snakeBody[0] = SnakeBodyPart(x: newLocation, y: snakeBody[0].locationY)
            case .Left:
                (snakeBody[0].locationX - 1.0 < xLowerBound) ? (newLocation = xUpperBound) : (newLocation = snakeBody[0].locationX - 1)
                snakeBody[0] = SnakeBodyPart(x: newLocation, y: snakeBody[0].locationY)
            }
        }else {
            var newLocation : Float
            
            switch direction {
            case .Up:
                newLocation = snakeBody[0].locationY - 1.0
                snakeBody[0] = SnakeBodyPart(x: snakeBody[0].locationX, y: newLocation)
            case .Down:
                newLocation = snakeBody[0].locationY + 1.0
                snakeBody[0] = SnakeBodyPart(x: snakeBody[0].locationX, y: newLocation)
            case .Right:
                newLocation = snakeBody[0].locationX + 1.0
                snakeBody[0] = SnakeBodyPart(x: newLocation, y: snakeBody[0].locationY)
            case .Left:
                newLocation = snakeBody[0].locationX - 1.0
                snakeBody[0] = SnakeBodyPart(x: newLocation, y: snakeBody[0].locationY)
            }
        }

    }
    
    func grow() {
        snakeBody.insert(tailBodyPart, atIndex: snakeBody.count)
    }
    
    func destroy() {
        snakeBody.removeAll(keepCapacity: false)
    }
    
}

struct SnakeBodyPart {
    
    // MARK: Properties
    var locationX: Float = 0.0
    var locationY: Float = 0.0
    
    init(x: Float, y: Float) {
        locationX = x
        locationY = y
    }
    
    func description() -> String {
        return "x: \(locationX) y: \(locationY)"
    }
    
}
