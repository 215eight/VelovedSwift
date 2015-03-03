//
//  Snake.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit


enum Direction : UInt{
    case up
    case down
    case right
    case left
    
}

class Snake : NSObject {
    
    // MARK: Properties
    var snakeBody = [SnakeBodyPart]()
    var xUpperBound : Float = 0
    var yUpperBound : Float = 0
    
    var snakeWidth : Float = 10.0
    
    var delegate : UIView?
    
    // MARK: Initializers
    
    init(xUpperBound: Float, yUpperBound: Float) {
        super.init()
        self.xUpperBound = xUpperBound
        self.yUpperBound = yUpperBound
    }
    
    // MARK: Class Methods
    
    class func createRandomSnake(size: Int, xUpperBound: Float, yUpperBound: Float) -> Snake {
        
        let snake = Snake(xUpperBound: xUpperBound, yUpperBound: yUpperBound)
        
        // TODO: Randomize creation
        
        for bodyPartIndex in 0 ..< size {
            let bodyPartLocationY = 150 + Float(bodyPartIndex) * snake.snakeWidth
            let bodyPart = SnakeBodyPart(x: 100, y: bodyPartLocationY)
            snake.snakeBody.insert(bodyPart, atIndex: 0)
        }
        
        return snake
    }
    
    // MARK: Instance Methods
    func move(direction: Direction, continuos: Bool, scaleFactor: Float) {
        
        precondition(snakeBody.count >= 2, "Snake should be at lest 2 units long")
        
        //Save the tail body part
        var tailBodyPart : SnakeBodyPart
        if let lastPoint = snakeBody.last {
            tailBodyPart = lastPoint
        }
        
        //Swift all positions, except the origin, by one starting from the last position
        for index in reverse(1 ..< snakeBody.count) {
            snakeBody[index] = snakeBody[index-1]
        }
        
        //Generate new origin
        
        let scaledSnakeWidth = snakeWidth * scaleFactor
        
        if continuos {
            switch direction {
            case .up:
                snakeBody[0] = SnakeBodyPart(x:snakeBody[0].locationX, y:snakeBody[0].locationY - scaledSnakeWidth)
            case .down:
                snakeBody[0] = SnakeBodyPart(x:snakeBody[0].locationX, y:snakeBody[0].locationY + scaledSnakeWidth)
            case .right:
                snakeBody[0] = SnakeBodyPart(x:snakeBody[0].locationX + scaledSnakeWidth, y:snakeBody[0].locationY)
            case .left:
                snakeBody[0] = SnakeBodyPart(x:snakeBody[0].locationX - scaledSnakeWidth, y:snakeBody[0].locationY)
            }
        }else {
            var newLocation : Float
            
            switch direction {
            case .up:
                (snakeBody[0].locationY - 1.0 < 0) ? (newLocation = yUpperBound - scaledSnakeWidth) : (newLocation = snakeBody[0].locationY - scaledSnakeWidth)
                snakeBody[0] = SnakeBodyPart(x: snakeBody[0].locationX, y: newLocation)
            case .down:
                (snakeBody[0].locationY + 1.0 > yUpperBound - 1.0) ? (newLocation = 0) : (newLocation = snakeBody[0].locationY + scaledSnakeWidth)
                snakeBody[0] = SnakeBodyPart(x: snakeBody[0].locationX, y: newLocation)
            case .right:
                (snakeBody[0].locationX + 1.0 > xUpperBound - 1.0) ? (newLocation = 0) : (newLocation = snakeBody[0].locationX + scaledSnakeWidth)
                snakeBody[0] = SnakeBodyPart(x: newLocation, y: snakeBody[0].locationY)
            case .left:
                (snakeBody[0].locationX - 1.0 < 0) ? (newLocation = xUpperBound - scaledSnakeWidth) : (newLocation = snakeBody[0].locationX - scaledSnakeWidth)
                snakeBody[0] = SnakeBodyPart(x: newLocation, y: snakeBody[0].locationY)
            }
        }
        
        delegate?.setNeedsDisplay()
        
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
