//
//  AppleView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class AppleView: UIView {

    // MARK: Properties 
    
    var apple: Apple!
    var appleRadius: CGFloat = 5.0
    var scaleFactor: CGFloat = 1.0 {
        didSet {
            resizeFrame()
        }
    }
    var xOffset: CGFloat = 0 {
        didSet {
            resizeFrame()
        }
    }
    var yOffset: CGFloat = 0 {
        didSet {
            resizeFrame()
        }
    }
    
    
    // MARK: Initializer
    
    convenience init(apple: Apple, appleRadius: CGFloat) {
        let frame = CGRectZero
        self.init(frame: frame)
        
        self.apple = apple
        self.appleRadius = appleRadius
        
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
        self.frame.size = CGSize(width: appleRadius * 2, height: appleRadius * 2)
        let centerX = xOffset + CGFloat(apple.locationX) * scaleFactor
        let centerY = yOffset + CGFloat(apple.locationY) * scaleFactor
        self.center = CGPoint(x: centerX, y: centerY)
    }

    func updateAppleLocation() {
        apple.updateLocation()
    }
    
    override func drawRect(rect: CGRect) {
        
        // Figure out the center of the bounds rectagle
        let centerX = (bounds.size.width / 2.0)
        let centerY = (bounds.size.height / 2.0)
        let boundsCenter = CGPoint(x: centerX, y: centerY)
        
        // Save graphics context
        let path = UIBezierPath()
        path.addArcWithCenter(boundsCenter,
            radius: appleRadius,
            startAngle: 0,
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        
        UIColor.redColor().setFill()
        path.fill()

    }
}
