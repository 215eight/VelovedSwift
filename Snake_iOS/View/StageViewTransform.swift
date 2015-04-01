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
        let stageFrame = frameCurrentOrientation(frame)
        scaleFactor = calculateScaleFactor(stageFrame, stageSize: stageSize)
        let offset = calculateOffset(stageFrame, scaleFactor: scaleFactor, stageSize: stageSize)
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
    
    func getDirection(direction: UISwipeGestureRecognizerDirection) -> UISwipeGestureRecognizerDirection {
        return getDirection(direction, orientation: currentOrientation)
    }
    
    
    func getDirection(direction: UISwipeGestureRecognizerDirection, orientation: UIDeviceOrientation) -> UISwipeGestureRecognizerDirection {
        
        var newDirection: UISwipeGestureRecognizerDirection
        
        switch currentOrientation {
        case .Portrait:
            newDirection = direction
        case .PortraitUpsideDown:
            newDirection = reverseDirection(direction)
        case .LandscapeLeft:
            if direction == .Up || direction == .Down {
                newDirection = reverseDirection(direction)
                newDirection = inverseDirection(newDirection)
            }else {
                newDirection = inverseDirection(direction)
            }
        case .LandscapeRight:
            if direction == .Right || direction == .Left {
                newDirection = reverseDirection(direction)
                newDirection = inverseDirection(newDirection)
            }else {
                newDirection = inverseDirection(direction)
            }
        default:
            newDirection = direction
        }
        
        return newDirection
    }
    
    // Helper method
    func frameCurrentOrientation(frame: CGRect) -> CGRect {
        var stageFrame: CGRect
        
        switch currentOrientation{
        case .LandscapeRight, .LandscapeLeft:
            stageFrame = CGRect(x: frame.origin.y, y: frame.origin.x, width: frame.size.height, height: frame.size.width)
        default:
            stageFrame = frame
        }
        return stageFrame
    }
    
    func reverseDirection(direction: UISwipeGestureRecognizerDirection) -> UISwipeGestureRecognizerDirection {
        
        var axisMask: UInt8
        
        switch direction {
        case UISwipeGestureRecognizerDirection.Right, UISwipeGestureRecognizerDirection.Left:
            axisMask = 0b00000011
        case UISwipeGestureRecognizerDirection.Up, UISwipeGestureRecognizerDirection.Down:
            axisMask = 0b00001100
        default:
            assertionFailure("Invalid direction value")
            break
        }
        
        var rawDirection = UInt8(direction.rawValue)
        let axisDirection = rawDirection & axisMask
        let reversedAxisDirection = ~axisDirection & axisMask
        
        return UISwipeGestureRecognizerDirection(UInt(reversedAxisDirection))
    }
    
    func inverseDirection(direction: UISwipeGestureRecognizerDirection) -> UISwipeGestureRecognizerDirection {
        
        let inversedDirections = UInt8(direction.rawValue << 2)
        
        let lowerInversedDirection = inversedDirections & 0b00001111
        let upperInversedDirection = (inversedDirections & 0b11110000) >> 4
        
        let inversedDirection = max(upperInversedDirection, lowerInversedDirection)
        
        return UISwipeGestureRecognizerDirection(UInt(inversedDirection))
        
    }
}
