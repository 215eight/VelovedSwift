//
//  StageView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class StageView: UIView {

    // MARK: Properties
    let inset: CGFloat = 4.0
    let borderWidth:  CGFloat = 4.0
    var gridUnitSize: CGFloat = 1.0
    
    
    // Calculate padding on x and y axis to make sure the size of the grid / stage fits complete grid  units
    var xPadding: CGFloat {
        return ((self.bounds.size.width - ((inset + (borderWidth / 2.0)) * 2)) % gridUnitSize) / 2
    }
    var yPadding: CGFloat {
        return ((self.bounds.size.height - ((inset + (borderWidth / 2.0)) * 2)) % gridUnitSize) / 2
    }
    
    var originX: CGFloat {
        return (self.bounds.origin.x + inset + (borderWidth / 2.0) + xPadding)
    }
    
    var originY: CGFloat {
        return (self.bounds.origin.y + inset + (borderWidth / 2.0) + yPadding)
    }
    
    var width: CGFloat {
        return (self.bounds.size.width - ((inset + (borderWidth / 2.0) + xPadding) * 2))
    }
    
    var height: CGFloat {
        return (self.bounds.size.height - ((inset + (borderWidth / 2.0) + yPadding) * 2))
    }
    
    var scaledWidth: CGFloat {
        return (width / gridUnitSize)
    }
    
    var scaledHeight: CGFloat {
        return (height / gridUnitSize)
    }
    
    var scaleFactor: CGFloat {
        return max(scaledWidth, scaledHeight)
    }
    
    var bottomBorder: CGRect {
        let origin = CGPoint(x: 0, y: originY + height)
        let size = CGSize(width: self.bounds.size.width, height: originY)
        return CGRect(origin: origin, size: size)
    }
    
    var stageBorders: [CGRect] {
        return [topBorder, bottomBorder, leftBorder, rightBorder]
    }
    
    var topBorder: CGRect {
        let origin = CGPoint(x: 0, y: 0)
        let size = CGSize(width: self.bounds.size.width, height: originY)
        
        return CGRect(origin: origin, size: size)
    }
    
    var leftBorder: CGRect {
        let origin = CGPoint(x: 0, y: 0)
        let size = CGSize(width: originX, height: self.bounds.size.height)
        
        return CGRect(origin: origin, size: size)
    }
    
    var rightBorder: CGRect {
        let origin = CGPoint(x: originX + width, y: 0)
        let size = CGSize(width: originX, height: self.bounds.size.height)
        
        return CGRect(origin: origin, size: size)
    }
    
    // MARK: Initializers
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    // MARK: UIView Methods
    override func drawRect(rect: CGRect) {
        
        // Inset Rect
        let insetRect = CGRectInset(self.bounds, inset + xPadding, inset + yPadding)
        
        var path = UIBezierPath(rect: insetRect)
        path.lineWidth = borderWidth
        UIColor.blackColor().setStroke()
        path.stroke()
    }

}
