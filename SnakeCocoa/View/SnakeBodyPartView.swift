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
    var bodyPart : SnakeBodyPart
    var size: CGSize = CGSizeZero
    var scaleFactor: CGFloat
    var offset: CGPoint
    
    init(bodyPart: SnakeBodyPart, gridUnits: CGFloat, scaleFactor: CGFloat,offset: CGPoint) {
        self.bodyPart = bodyPart
        self.bodyPart.locationX *= Float(scaleFactor)
        self.bodyPart.locationY *= Float(scaleFactor)
        self.size.width = gridUnits * scaleFactor
        self.size.height = gridUnits * scaleFactor
        self.scaleFactor = scaleFactor
        self.offset = offset
        
        // Calculate view origin
        let originX = CGFloat(self.bodyPart.locationX) - (size.width / 2)
        let originY = CGFloat(self.bodyPart.locationY) - (size.height / 2)
        let origin = CGPoint(x: CGFloat(originX), y: CGFloat(originY))
        
        let frame = CGRect(origin: origin, size: self.size)
        
        super.init(frame: frame)
    }
    
    // MARK: Initializer
    required init(coder aDecoder: NSCoder) {
        fatalError("\(SnakeBodyPartView.className()) class does not support initialization using an NSCoder.")
    }
    
    // MARK: UIView methods
    
    override func drawRect(rect: CGRect) {
        
        switch bodyPart.type {
        case .Head:
            drawHead()
        case .Body:
            drawBodyPart()
        }
    }
    
    func drawHead() {
        let path = UIBezierPath(rect: self.bounds)
        UIColor.greenColor().setFill()
        path.fill()
    }
    
    func drawBodyPart() {
        
        var drawingDirection: Direction
        
        // If there was a change in direction (oldDirection != nil)
        // Then we should draw the body part in the old direction and then animate the move to the current direction
        // If there was a change in direction, just draw the body part
        
        if bodyPart.oldDirection != nil { drawingDirection = bodyPart.oldDirection! }
        else { drawingDirection = bodyPart.direction }
        
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
        
        if bodyPart.oldDirection != nil {
            let degrees = Direction.degreeRotationChange(bodyPart.oldDirection!, toDirection:bodyPart.direction)
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
