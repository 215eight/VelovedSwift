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
    var xLowerBound: Float
    var yLowerBound: Float
    var xUpperBound: Float
    var yUpperBound: Float
    
    var snakeHead : SnakeBodyPart? {
        if snakeBody.count > 1 {
            return snakeBody[0]
        }
        return nil
    }
    var tailBodyPart = SnakeBodyPart(x: 0, y: 0)
    
    // MARK: Initializers
    
    init(xLowerBound: Float, xUpperBound: Float, yLowerBound: Float, yUpperBound: Float) {
        self.xLowerBound = xLowerBound
        self.xUpperBound = xUpperBound
        self.yLowerBound = yLowerBound
        self.yUpperBound = yUpperBound
        
        super.init()
    }
    
    // MARK: Class Methods
    
    class func createRandomSnake(xLowerBound: Float, xUpperBound: Float, yLowerBound: Float, yUpperBound: Float) -> Snake {
        
        let snake = Snake(xLowerBound: xLowerBound, xUpperBound: xUpperBound, yLowerBound: yLowerBound, yUpperBound: yUpperBound)
        
        // TODO: Randomize creation
        let bodySize = 5
        let bodyPartLocationX = xLowerBound + 0
        for bodyPartIndex in 0 ..< bodySize {
            let bodyPartLocationY = yLowerBound + 0 + Float(bodyPartIndex)
            let bodyPart = SnakeBodyPart(x: bodyPartLocationX, y: bodyPartLocationY)
            snake.snakeBody.insert(bodyPart, atIndex: 0)
        }
        
        return snake
    }
    
    // MARK: Instance Methods
//    func move(direction: Direction, continuos: Bool, scaleFactor: Float) {
//        
//        precondition(snakeBody.count >= 2, "Snake should be at lest 2 units long")
//        
//        //Save the tail body part
//        if let lastPoint = snakeBody.last {
//            tailBodyPart = lastPoint
//        }
//        
//        //Swift all positions, except the origin, by one starting from the last position
//        for index in reverse(1 ..< snakeBody.count) {
//            snakeBody[index] = snakeBody[index-1]
//        }
//        
//        //Generate new origin
//        
//        let scaledSnakeWidth = width * scaleFactor
//        
//        if continuos {
//            switch direction {
//            case .up:
//                snakeBody[0] = SnakeBodyPart(x:snakeBody[0].locationX, y:snakeBody[0].locationY - scaledSnakeWidth)
//            case .down:
//                snakeBody[0] = SnakeBodyPart(x:snakeBody[0].locationX, y:snakeBody[0].locationY + scaledSnakeWidth)
//            case .right:
//                snakeBody[0] = SnakeBodyPart(x:snakeBody[0].locationX + scaledSnakeWidth, y:snakeBody[0].locationY)
//            case .left:
//                snakeBody[0] = SnakeBodyPart(x:snakeBody[0].locationX - scaledSnakeWidth, y:snakeBody[0].locationY)
//            }
//        }else {
//            var newLocation : Float
//            
//            switch direction {
//            case .up:
//                (snakeBody[0].locationY - 1.0 < 0) ? (newLocation = yUpperBound - scaledSnakeWidth) : (newLocation = snakeBody[0].locationY - scaledSnakeWidth)
//                snakeBody[0] = SnakeBodyPart(x: snakeBody[0].locationX, y: newLocation)
//            case .down:
//                (snakeBody[0].locationY + 1.0 > yUpperBound - 1.0) ? (newLocation = 0) : (newLocation = snakeBody[0].locationY + scaledSnakeWidth)
//                snakeBody[0] = SnakeBodyPart(x: snakeBody[0].locationX, y: newLocation)
//            case .right:
//                (snakeBody[0].locationX + 1.0 > xUpperBound - 1.0) ? (newLocation = 0) : (newLocation = snakeBody[0].locationX + scaledSnakeWidth)
//                snakeBody[0] = SnakeBodyPart(x: newLocation, y: snakeBody[0].locationY)
//            case .left:
//                (snakeBody[0].locationX - 1.0 < 0) ? (newLocation = xUpperBound - scaledSnakeWidth) : (newLocation = snakeBody[0].locationX - scaledSnakeWidth)
//                snakeBody[0] = SnakeBodyPart(x: newLocation, y: snakeBody[0].locationY)
//            }
//        }
//
//    }
    
    func grow() {
        snakeBody.insert(tailBodyPart, atIndex: snakeBody.count)
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
