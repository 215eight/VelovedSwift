//
//  StageViewTransform.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class StageViewTransform: NSObject {
    
    let stageSize: StageSize!
    let offset: CGPoint!
    let scaleFactor: CGFloat!
    var currentOrientation: UIDeviceOrientation!
    
    
    var stageFrame: CGRect {
        
        let sWidth = CGFloat(stageSize.width) * scaleFactor
        let sHeight = CGFloat(stageSize.height) * scaleFactor
        let sSize = CGSize(width: sWidth, height: sHeight)
        
        return CGRect(origin: offset, size: sSize)
    }
    
    
    init(frame: CGRect, stageSize: StageSize) {
        super.init()
        
        self.stageSize = stageSize
        scaleFactor = calculateScaleFactor(frame, stageSize: stageSize)
        offset = calculateOffset(frame, scaleFactor: scaleFactor, stageSize: stageSize)
        
        currentOrientation = UIDevice.currentDevice().orientation
        
    }
    
    func calculateScaleFactor(frame: CGRect, stageSize: StageSize) -> CGFloat {
        
        // Find the grid size
        let widthRatio = frame.size.width / CGFloat(stageSize.width)
        let heightRatio = frame.size.height / CGFloat(stageSize.height)
        
        // find the smallest ratio and use it a the grid size
        return min(widthRatio, heightRatio)
    }
    
    func calculateOffset(frame: CGRect, scaleFactor: CGFloat, stageSize: StageSize) -> CGPoint {
        
        // Calculate the size of the grid
        
        let width = CGFloat(stageSize.width) * scaleFactor
        let height = CGFloat(stageSize.height) * scaleFactor
        
        // Find the padding on each axis
        let offsetX = (frame.width - width) / 2
        let offsetY = (frame.height - height) / 2
        
        return CGPoint(x: offsetX, y: offsetY)
    }
    
    func getFrame(location: StageLocation) -> CGRect {
        
        return getFrame(location, orientation: currentOrientation)
    }
    
    func getFrame(location: StageLocation, orientation: UIDeviceOrientation) -> CGRect {
        
        var location = CGPoint(x: CGFloat(location.x), y: CGFloat(location.y))
        
       
        var transform: CGAffineTransform
        
        switch orientation {
        case .Portrait:
            transform = CGAffineTransformIdentity
        case .LandscapeLeft:
            let xTrns = location.y
            let yTrns = location.x
            transform = CGAffineTransformMakeTranslation(xTrns, yTrns)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        case .LandscapeRight:
            let xTrns = location.y
            let yTrns = location.x
            transform = CGAffineTransformMakeTranslation(xTrns, yTrns)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        default:
            transform = CGAffineTransformIdentity
        }
        
        location = CGPointApplyAffineTransform(location, transform)
        
        let originX = location.x * scaleFactor
        let originY = location.y * scaleFactor
        let origin = CGPoint(x: originX, y: originY)
        let size = CGSize(width: scaleFactor, height: scaleFactor)
        return CGRect(origin: origin, size: size)
    }
}
