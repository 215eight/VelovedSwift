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
    let scaleFactor: CGFloat!
    var currentOrientation: UIDeviceOrientation {
        return UIDevice.currentDevice().orientation
    }
    
    private var _xOffset: CGFloat!
    private var _yOffset: CGFloat!
    
    var offset: CGPoint {
        
        var xOffset: CGFloat
        var yOffset: CGFloat
        
        switch currentOrientation {
        case .Portrait, .PortraitUpsideDown:
            xOffset = _xOffset
            yOffset = _yOffset
        case .LandscapeLeft, .LandscapeRight:
            xOffset = _yOffset
            yOffset = _xOffset
        default:
            xOffset = _xOffset
            yOffset = _yOffset
        }
        
        println("Offset - x: \(xOffset) y: \(yOffset)")
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    private let _sWidth: CGFloat!
    private let _sHeight: CGFloat!
    
    var stageFrame: CGRect {
        
        var sWidth: CGFloat
        var sHeight: CGFloat
        
        switch currentOrientation {
        case .Portrait, .PortraitUpsideDown:
            sWidth = _sWidth
            sHeight = _sHeight
        case .LandscapeLeft, .LandscapeRight:
            sWidth = _sHeight
            sHeight = _sWidth
        default:
            sWidth = _sWidth
            sHeight = _sHeight
        }
        let sSize = CGSize(width: sWidth, height: sHeight)
        
        return CGRect(origin: offset, size: sSize)
    }
    
    init(frame: CGRect, stageSize: StageSize) {
        super.init()
        
        
        self.stageSize = stageSize
        let portraitFrame = framePortraitSize(frame)
        scaleFactor = calculateScaleFactor(portraitFrame, stageSize: stageSize)
        let offset = calculateOffset(portraitFrame, scaleFactor: scaleFactor, stageSize: stageSize)
        _xOffset = offset.0
        _yOffset = offset.1
        
        _sWidth = CGFloat(stageSize.width) * scaleFactor
        _sHeight = CGFloat(stageSize.height) * scaleFactor
        
    }
    
    func calculateScaleFactor(frame: CGRect, stageSize: StageSize) -> CGFloat {
        
        // Find the grid size
        let widthRatio = frame.size.width / CGFloat(stageSize.width)
        let heightRatio = frame.size.height / CGFloat(stageSize.height)
        
        // find the smallest ratio and use it a the grid size
        return min(widthRatio, heightRatio)
    }
    
    func calculateOffset(frame: CGRect, scaleFactor: CGFloat, stageSize: StageSize) -> (CGFloat, CGFloat) {
        
        // Calculate the size of the grid
        
        let width = CGFloat(stageSize.width) * scaleFactor
        let height = CGFloat(stageSize.height) * scaleFactor
        
        // Find the padding on each axis
        let offsetX = (frame.width - width) / 2
        let offsetY = (frame.height - height) / 2
        
        return (offsetX, offsetY)
    }
    
    func getFrame(location: StageLocation) -> CGRect {
        
        return getFrame(location, orientation: currentOrientation)
    }
    
    func getFrame(location: StageLocation, orientation: UIDeviceOrientation) -> CGRect {
        
        var newLocation: StageLocation
        
        switch orientation {
        case .Portrait:
            newLocation = location
        case .PortraitUpsideDown:
            let xTrns = stageSize.width - 1 - location.x
            let yTrns = stageSize.height - 1 - location.y
            newLocation = StageLocation(x: xTrns, y: yTrns)
        case .LandscapeLeft:
            let xTrns = location.y
            let yTrns = stageSize.width - 1 - location.x
            newLocation = StageLocation(x: xTrns, y: yTrns)
        case .LandscapeRight:
            let xTrns = stageSize.height - 1 - location.y
            let yTrns = location.x
            newLocation = StageLocation(x: xTrns, y: yTrns)
        default:
            newLocation = location
        }
        
        let originX = CGFloat(newLocation.x) * scaleFactor
        let originY = CGFloat(newLocation.y) * scaleFactor
        let origin = CGPoint(x: originX, y: originY)
        let size = CGSize(width: scaleFactor, height: scaleFactor)
        return CGRect(origin: origin, size: size)
    }
    
    // Helpe method
    func framePortraitSize(frame: CGRect) -> CGRect {
        var portraitFrame: CGRect
        
        switch currentOrientation{
        case .LandscapeRight, .LandscapeLeft:
            portraitFrame = CGRect(x: frame.origin.y, y: frame.origin.x, width: frame.size.height, height: frame.size.width)
        default:
            portraitFrame = frame
        }
        return portraitFrame
    }
}
