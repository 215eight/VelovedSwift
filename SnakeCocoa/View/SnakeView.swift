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
    
    var snake : Snake?{
        didSet{
            snake!.snakeBody.first
        }
    }
    var snakeHead : CGRect?
    var scaleFactor: CGFloat = 1.0

    // MARK: Initializers
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
        
    }
    
    // MARK: UIView methods
    override func drawRect(rect: CGRect) {
        
        // Draw body
        if let snakeObj = snake {
            for bodyPart in snakeObj.snakeBody {
                let bodyPartCenter = CGPoint(x: CGFloat(bodyPart.locationX), y: CGFloat(bodyPart.locationY))
                drawSquareWithCenter(bodyPartCenter, sideSize: CGFloat(snakeObj.snakeWidth))
            }
        }
        
        // Redraw head
        if let snakeObj = snake {
            if let head = snakeObj.snakeBody.first {
                let bodyPartCenter = CGPoint(x: CGFloat(head.locationX), y: CGFloat(head.locationY))
                drawSquareWithCenter(bodyPartCenter, sideSize: CGFloat(snakeObj.snakeWidth), color: UIColor.purpleColor())
            }
        }
    }
    
    func drawSquareWithCenter(center: CGPoint, sideSize: CGFloat, color: UIColor) {
        
        // Save graphics context
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        CGContextScaleCTM(context, scaleFactor, scaleFactor)
        
        let path = UIBezierPath()
        
        //Create cue points
        let halfSideSize = sideSize / 2
        let scaledCenterX = center.x / scaleFactor
        let scaledCenterY = center.y / scaleFactor
        let leftBottom = CGPoint(x: (scaledCenterX - (halfSideSize)), y: (scaledCenterY + (halfSideSize)))
        let leftTop = CGPoint(x: (scaledCenterX - halfSideSize), y: (scaledCenterY - (halfSideSize)))
        let rightTop = CGPoint(x: (scaledCenterX + (halfSideSize)), y: (scaledCenterY - (halfSideSize)))
        let rightBottom = CGPoint(x: (scaledCenterX + (halfSideSize)), y: (scaledCenterY + (halfSideSize)))
        
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
}
