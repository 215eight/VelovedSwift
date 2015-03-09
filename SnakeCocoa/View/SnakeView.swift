//
//  SnakeView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SnakeView: UIView {
    
    // MARK: Properties
    
    var snake: Snake?
    var snakeWidth: CGFloat = 10.0
    var xOffset: CGFloat = 0
    var yOffset: CGFloat = 0
    var snakeHeadRect: CGRect? {
        if let snakeObj = snake {
            let head = snakeObj.snakeHead
            let headCenter = CGPoint(x: CGFloat(head.locationX), y: CGFloat(head.locationY))
            return bodyPartRect(headCenter)
        }
        return nil
    }
    
    var bodyPartsRects: [CGRect]? {
        if let snakeObj = snake {
            let body = snakeObj.snakeBody
            var bodyPartsRects = body.map() { (bodyPart: SnakeBodyPart) -> CGRect in
                let center = CGPoint(x: CGFloat(bodyPart.locationX), y: CGFloat(bodyPart.locationY))
                return self.bodyPartRect(center)
            }
            
            // Remove the head
            bodyPartsRects.removeAtIndex(0)
            return bodyPartsRects
        }
        return nil
    }
    
    var scaleFactor: CGFloat = 1.0

    // MARK: Initializers
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.clearColor()
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    // MARK: UIView methods
    override func drawRect(rect: CGRect) {
        
        // Draw body
        if let snakeObj = snake {
            for bodyPart in snakeObj.snakeBody {
                let bodyPartCenter = CGPoint(x: CGFloat(bodyPart.locationX), y: CGFloat(bodyPart.locationY))
                drawSquareWithCenter(bodyPartCenter, sideSize: snakeWidth)
            }
        }
        
        // Redraw head
        if let snakeObj = snake {
            let head = snakeObj.snakeHead
            let bodyPartCenter = CGPoint(x: CGFloat(head.locationX), y: CGFloat(head.locationY))
            drawSquareWithCenter(bodyPartCenter, sideSize: snakeWidth, color: UIColor.purpleColor())
        }
    }
    
    func drawSquareWithCenter(center: CGPoint, sideSize: CGFloat, color: UIColor) {
        
        // Save graphics context
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        CGContextTranslateCTM(context, xOffset, yOffset)
        CGContextScaleCTM(context, scaleFactor, scaleFactor)
        
        let path = UIBezierPath()
        
        //Create cue points
        let halfSideSize = sideSize / (2 * scaleFactor)
        let leftBottom = CGPoint(x: (center.x - (halfSideSize)), y: (center.y + (halfSideSize)))
        let leftTop = CGPoint(x: (center.x - halfSideSize), y: (center.y - (halfSideSize)))
        let rightTop = CGPoint(x: (center.x + (halfSideSize)), y: (center.y - (halfSideSize)))
        let rightBottom = CGPoint(x: (center.x + (halfSideSize)), y: (center.y + (halfSideSize)))
        
        //Connect points
        path.moveToPoint(leftBottom)
        path.addLineToPoint(leftTop)
        path.addLineToPoint(rightTop)
        path.addLineToPoint(rightBottom)
        path.closePath()
        
        //Fill the path
        color.setFill()
        path.fill()
        
        // Restore graphics context
        CGContextRestoreGState(context)
    }
    
    func drawSquareWithCenter(center: CGPoint, sideSize: CGFloat) {
        drawSquareWithCenter(center, sideSize: sideSize, color: UIColor.greenColor())
    }
    
    // MARK: Instance methods
    
    func bodyPartRect(center: CGPoint) -> CGRect {
        let originX = (center.x * scaleFactor) - (snakeWidth / 2) + xOffset
        let originY = (center.y * scaleFactor) - (snakeWidth / 2) + yOffset
        return CGRect(x: originX, y: originY, width: snakeWidth, height: snakeWidth)
    }
    
    func clearView() {
        if let snakeObj = snake {
            snakeObj.destroy()
            setNeedsDisplay()
        }
    }

    func steerSnake(direction: Direction) {
        if let snakeObj = snake {
            //snakeObj.setDirection(direction)
        }
    }
    
    func moveSnake(#continuous: Bool) {
        snake?.move(continuous: continuous)
    }
    
    func growSnake() {
        snake?.grow()
    }
}
