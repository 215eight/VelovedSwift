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
    
    private var gridUnitSize: CGFloat = 0
    private var appleSize: CGSize = CGSizeZero
    private var appleCenter: CGPoint = CGPointZero
    private var viewOffset: CGPoint = CGPointZero
    
    
    // MARK: Initializer
    
    init(gridUnits: CGFloat, gridUnitSize: CGFloat, viewOffset: CGPoint){
        super.init(frame: CGRectZero)
        self.gridUnitSize = gridUnitSize
        let appleWidth = gridUnits * gridUnitSize
        let appleHeight = gridUnits * gridUnitSize
        self.appleSize = CGSize(width: appleWidth, height: appleHeight)
        self.viewOffset = viewOffset
        
        backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("\(SnakeBodyPartView.className()) class does not support initialization using an NSCoder.")
    }
    
    func setLocation(apple: Apple) {
//        calculateOrigin(apple)
        frame = CGRectMake(appleCenter.x, appleCenter.y, appleSize.width, appleSize.height)
    }
    
//    private func calculateOrigin(apple: Apple){
//        let originX = viewOffset.x + CGFloat(apple.locationX) * gridUnitSize
//        let originY = viewOffset.y + CGFloat(apple.locationY) * gridUnitSize
//        appleCenter = CGPoint(x: originX, y: originY)
//    }
//    
    override func drawRect(rect: CGRect) {
        
        // Figure out the center of the bounds rectagle
        let centerX = (bounds.size.width / 2.0)
        let centerY = (bounds.size.height / 2.0)
        let boundsCenter = CGPoint(x: centerX, y: centerY)
        
        let path = UIBezierPath()
        path.addArcWithCenter(boundsCenter,
            radius: appleSize.width / 2.0,
            startAngle: 0,
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        
        UIColor.redColor().setFill()
        path.fill()

    }
}
