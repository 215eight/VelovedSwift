//
//  AppleView.swift
//  SnakeSwift
//
//  Created by PartyMan on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class AppleView: UIView {

    // MARK: Properties 
    
    var apple: Apple!
    var scaleFactor: CGFloat = 1.0 {
        didSet{
            // Resize the frame to prepare next re-draw
            resizeFrame()
        }
    }
    
    
    // MARK: Initializer
    
    convenience init(apple: Apple) {
        let frame = CGRectZero
        self.init(frame: frame)
        
        self.apple = apple
        
        resizeFrame()
        
        backgroundColor = UIColor.clearColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func resizeFrame() {
        //apple.size is the radius of the circle thus needs to be multiplied by 2
        self.frame.size = CGSize(width: CGFloat(apple.size) * 2 * scaleFactor, height: CGFloat(apple.size) * 2 * scaleFactor)
        self.center = CGPoint(x: CGFloat(apple.locationX), y: CGFloat(apple.locationY))
    }

    override func drawRect(rect: CGRect) {
        
        // Figure out the center of the bounds rectagle
        let boundsX = (bounds.origin.x + bounds.size.width) / (2.0 * scaleFactor)
        let boundsY = (bounds.origin.y + bounds.size.height) / (2.0 * scaleFactor)
        let boundsCenter = CGPoint(x: boundsX, y: boundsY)
 
        // Save graphics context
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        CGContextScaleCTM(context, scaleFactor, scaleFactor)
        
        let path = UIBezierPath()
        path.addArcWithCenter(boundsCenter,
            radius: CGFloat(apple.size),
            startAngle: 0,
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        
        UIColor.redColor().setFill()
        path.fill()
        
        // Restore graphics context
        CGContextRestoreGState(context)
    }

}
