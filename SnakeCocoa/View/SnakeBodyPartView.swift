//
//  SnakeBodyPartView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SnakeBodyPartView: UIView {

    // MARK: Properties
    var size: CGSize
    var offset: CGPoint
    var direction: Direction {
        willSet {
            oldDirection = direction
        }
        didSet {
            println("Direction: \(direction)")
        }
    }
    var oldDirection: Direction? {
        didSet{
            println("Old Direction: \(oldDirection)")
        }
    }
    
    init(center: CGPoint, size: CGSize, offset: CGPoint, direction: Direction) {
        self.size = size
        self.offset = offset
        self.direction = direction
        
        // Calculate view origin
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        let origin = CGPoint(x: originX, y: originY)
        
        let frame = CGRect(origin: origin, size: size)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.greenColor()
    }
    
    // MARK: Initializer
    required init(coder aDecoder: NSCoder) {
        fatalError("\(SnakeBodyPartView.className()) class does not support initialization using an NSCoder.")
    }
    
    // MARK: UIView methods
    
    override func drawRect(rect: CGRect) {
        
        var drawingDirection: Direction
        
        // If there was a change in direction (oldDirection != nil)
        // Then we should draw the body part in the old direction and then animate the move to the current direction
        // If there was a change in direction, just draw the body part
        
        if oldDirection != nil { drawingDirection = oldDirection! }
        else { drawingDirection = direction }
        
        //Calculate fringe thickness
        let topBottomFringeWith = size.height * 0.3
        let middleFringeWidth = size.height * 0.4
        
        //Calculate fringe coordinates
        let topOriginY = size.height * 0.3 / 2
        let middleOriginY = size.height * 0.4 / 2 + size.height * 0.3
        let bottomOriginY = size.height * 0.3 / 2 + size.height * 0.7
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
       
        //Apply transforms depending on the direction
        if (drawingDirection == Direction.Right || drawingDirection == Direction.Left) {
            CGContextTranslateCTM(context, size.width, 0)
            let degrees = CGFloat(M_PI / 180) * 90
            CGContextRotateCTM(context, degrees)
        }
        
        // Draw fringes
        let path = UIBezierPath()
        
        //Top fringe
        path.moveToPoint(CGPoint(x: 0, y: topOriginY))
        path.addLineToPoint(CGPoint(x: size.width, y: topOriginY))
        path.lineWidth = topBottomFringeWith
        UIColor.blackColor().setStroke()
        path.stroke()
        
        // Middle fringe
        path.removeAllPoints()
        path.moveToPoint(CGPoint(x: 0, y: middleOriginY))
        path.addLineToPoint(CGPoint(x: size.width, y: middleOriginY))
        path.lineWidth = middleFringeWidth
        UIColor.yellowColor().setStroke()
        path.stroke()
        
        //Bottom fringe
        path.removeAllPoints()
        path.moveToPoint(CGPoint(x: 0, y: bottomOriginY))
        path.addLineToPoint(CGPoint(x: size.width, y: bottomOriginY))
        path.lineWidth = topBottomFringeWith
        UIColor.blackColor().setStroke()
        path.stroke()
        
        CGContextRestoreGState(context)
        
        if oldDirection != nil {
            let degrees = Direction.degreeRotationChange(oldDirection!, toDirection:direction)
            let backupTransform = self.transform
            UIView.animateWithDuration(0.5,
                delay:0,
                options: UIViewAnimationOptions.AllowUserInteraction,
                animations: {
                    
                    self.transform = CGAffineTransformMakeRotation(degrees)
                    println("Animating. Rotating: \(degrees)")
                },
                completion: { (finished: Bool) in
                    println("Finished animating \(finished)")
                })
            self.transform = backupTransform
        }
    }
    
    // MARK: Class methods
    class func className() -> String {
        return NSStringFromClass(SnakeBodyPartView.self)
    }
}
