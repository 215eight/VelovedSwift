//
//  iOS_StageViewTransform.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/8/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

struct iOS_StageViewTransform: DeviceStageViewTransform {
    
    private var scaleFactor: CGFloat!
    
    private var currentOrientation: StageOrientation {
        let deviceOrientation = UIDevice.currentDevice().orientation
        
        switch deviceOrientation {
        case .Portrait:
            return StageOrientation.Portrait
        case .LandscapeRight:
            return StageOrientation.LandscapeRight
        case .LandscapeLeft:
            return StageOrientation.LandscapeLeft
        case .PortraitUpsideDown:
            return StageOrientation.PortraitUpsideDown
        default:
            return StageOrientation.Unknow
        }
    }
    
    private var windowSize: CGSize {
        return UIScreen.mainScreen().fixedCoordinateSpace.bounds.size
    }

    init() {
        scaleFactor = calculateScaleFactor()
    }

    func calculateScaleFactor() -> CGFloat {
        return calculateScaleFactor(windowSize)
    }

    func calculateScaleFactor(windowSize: CGSize) -> CGFloat {
        let widthRatio = windowSize.width / CGFloat(DefaultStageSize.width)
        let heightRatio = windowSize.height / CGFloat(DefaultStageSize.height)
        
        return min(widthRatio, heightRatio)
    }

    func getStageFrame() -> CGRect {
        return getStageFrame(windowSize, scaleFactor: scaleFactor, orientation: currentOrientation)
    }
    
    func getStageFrame(windowSize: CGSize, scaleFactor: CGFloat, orientation: StageOrientation) -> CGRect {
        
        let sWidth = CGFloat(DefaultStageSize.width) * scaleFactor
        let sHeight = CGFloat(DefaultStageSize.height) * scaleFactor
        
        let sOriginX = (windowSize.width - sWidth) / 2
        let sOriginY = (windowSize.height - sHeight) / 2
        
        var origin: CGPoint
        var size: CGSize

        switch orientation {
        case .Portrait, .PortraitUpsideDown:
            origin = CGPoint(x: sOriginX, y: sOriginY)
            size = CGSize(width: sWidth, height: sHeight)
        case .LandscapeLeft, .LandscapeRight:
            origin = CGPoint(x: sOriginY, y: sOriginX)
            size = CGSize(width: sHeight, height: sWidth)
        default:
            origin = CGPoint(x: sOriginX, y: sOriginY)
            size = CGSize(width: sWidth, height: sHeight)
        }

        return CGRect(origin: origin, size: size)
    }

    func getFrame(location: StageLocation) -> CGRect {
        return getFrame(location, orientation: currentOrientation, scaleFactor: scaleFactor)
    }
    
    func getFrame(location: StageLocation, orientation: StageOrientation, scaleFactor: CGFloat) -> CGRect {
        
        var newLocation: StageLocation
        
        switch orientation {
        case .Portrait:
            newLocation = location
        case .PortraitUpsideDown:
            let xTrns = DefaultStageSize.width - 1 - location.x
            let yTrns = DefaultStageSize.height - 1 - location.y
            newLocation = StageLocation(x: xTrns, y: yTrns)
        case .LandscapeLeft:
            let xTrns = location.y
            let yTrns = DefaultStageSize.width - 1 - location.x
            newLocation = StageLocation(x: xTrns, y: yTrns)
        case .LandscapeRight:
            let xTrns = DefaultStageSize.height - 1 - location.y
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

    func getDirection(direction: Direction) -> Direction {
        return getDirection(direction, orientation: currentOrientation)
    }
    
    func getDirection(direction: Direction, orientation: StageOrientation) -> Direction {
        
        var newDirection: Direction
        
        switch orientation {
        case .Portrait:
            newDirection = direction
        case .PortraitUpsideDown:
            newDirection = Direction.reversedDirection(direction)
        case .LandscapeRight:
            if direction == .Right || direction == .Left {
                newDirection = Direction.reversedDirection(direction)
                newDirection = Direction.inversedDirection(newDirection)
            }else {
                newDirection = Direction.inversedDirection(direction)
            }
        case .LandscapeLeft:
            if direction == .Up || direction == .Down {
                newDirection = Direction.reversedDirection(direction)
                newDirection = Direction.inversedDirection(newDirection)
            }else {
                newDirection = Direction.inversedDirection(direction)
            }
        default:
            newDirection = direction
        }
        
        return newDirection
    }

    func getOriginalDirection(direction: Direction) -> Direction {
        return getOriginalDirection(direction, orientation: currentOrientation)
    }


    func getOriginalDirection(direction: Direction, orientation: StageOrientation) -> Direction {

        var newDirection: Direction

        switch orientation {
        case .Portrait:
            newDirection = direction
        case .PortraitUpsideDown:
            newDirection = Direction.reversedDirection(direction)
        case .LandscapeLeft:
            if direction == .Up || direction == .Down {
            newDirection = Direction.reversedDirection(direction)
            newDirection = Direction.inversedDirection(newDirection)
        }else {
            newDirection = Direction.inversedDirection(direction)
            }
        case .LandscapeRight:
            if direction == .Right || direction == .Left {
                newDirection = Direction.reversedDirection(direction)
                newDirection = Direction.inversedDirection(newDirection)
            }else {
                newDirection = Direction.inversedDirection(direction)
            }
        default:
            newDirection = direction
        }

        return newDirection
    }
    
}