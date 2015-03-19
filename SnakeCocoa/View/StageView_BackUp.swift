////
////  StageView.swift
////  SnakeSwift
////
////  Created by eandrade21 on 3/2/15.
////  Copyright (c) 2015 PartyLand. All rights reserved.
////
//
//import UIKit
//
//class StageView_Backup: UIView {
//
//    // MARK: Properties
//    let inset: CGFloat = 4.0
//    let borderWidth:  CGFloat = 4.0
//    var gridUnitSize: CGFloat
//    
//    // Calculate padding on x and y axis to make sure the size of the grid / stage fits complete grid  units
//    private var xPadding: CGFloat {
//        return ((self.bounds.size.width - ((inset + (borderWidth / 2.0)) * 2)) % gridUnitSize) / 2
//    }
//    private var yPadding: CGFloat {
//        return ((self.bounds.size.height - ((inset + (borderWidth / 2.0)) * 2)) % gridUnitSize) / 2
//    }
//    
//    private var originX: CGFloat {
//        return (self.bounds.origin.x + inset + (borderWidth / 2.0) + xPadding)
//    }
//    
//    private var originY: CGFloat {
//        return (self.bounds.origin.y + inset + (borderWidth / 2.0) + yPadding)
//    }
//    
//    var offset: CGPoint {
//        return CGPoint(x: originX, y: originY)
//    }
//    
//    private var width: CGFloat {
//        return (self.bounds.size.width - ((originX) * 2))
//    }
//    
//    private var height: CGFloat {
//        return (self.bounds.size.height - ((originY) * 2))
//    }
//    
//    var scaledWidth: CGFloat {
//        return (width / gridUnitSize)
//    }
//    
//    var scaledHeight: CGFloat {
//        return (height / gridUnitSize)
//    }
//    
//    var scaleFactor: CGFloat {
//        return gridUnitSize
//    }
//    
//    var stageBorders: [StageBorderView] {
//        return [topBorder, bottomBorder, leftBorder, rightBorder]
//    }
//
//    
//    // MARK: Initializers
//    
//    init(frame: CGRect, gridUnitSize: CGFloat) {
//        self.gridUnitSize = gridUnitSize
//        super.init(frame: frame)
//        setUpBorders()
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setUpBorders(){
//        
//        var borderFrame: CGRect
//        var borderOrigin: CGPoint
//        var borderSize: CGSize
//        
//        // Top border
//        borderOrigin = CGPoint(x: 0, y: 0)
//        borderSize = CGSize(width: self.bounds.size.width, height: originY)
//        borderFrame = CGRect(origin: borderOrigin, size: borderSize)
//        topBorder = StageBorderView(frame: borderFrame)
//        self.addSubview(topBorder)
//        
//        // Bottom border
//        borderOrigin = CGPoint(x: 0, y: originY + height)
//        borderSize = CGSize(width: self.bounds.size.width, height: originY)
//        borderFrame = CGRect(origin: borderOrigin, size: borderSize)
//        bottomBorder = StageBorderView(frame: borderFrame)
//        self.addSubview(bottomBorder)
//        
//        // Left border
//        borderOrigin = CGPoint(x: 0, y: 0)
//        borderSize = CGSize(width: originX, height: self.bounds.size.height)
//        borderFrame = CGRect(origin: borderOrigin, size: borderSize)
//        leftBorder = StageBorderView(frame: borderFrame)
//        self.addSubview(leftBorder)
//        
//        // Right border
//        borderOrigin = CGPoint(x: originX + width, y: 0)
//        borderSize = CGSize(width: originX, height: self.bounds.size.height)
//        borderFrame = CGRect(origin: borderOrigin, size: borderSize)
//        rightBorder = StageBorderView(frame: borderFrame)
//        self.addSubview(rightBorder)
//    }
//
//}
