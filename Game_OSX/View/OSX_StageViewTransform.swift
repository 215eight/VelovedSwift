//
//  OSX_StageViewTransform.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import VelovedCommon

struct OSX_StageViewTransform: DeviceStageViewTransform {

    private var scaleFactor: CGFloat!

    private var currentOrientation: StageOrientation = .LandscapeLeft

    private var windowFrame: CGRect

    init(frame: CGRect) {
        windowFrame = frame
        scaleFactor = calculateScaleFactor()
    }

    func calculateScaleFactor() -> CGFloat {
        // DefaultStageSize dimensions are based on a portrait orientaion
        // Since OSX is always landscape, dimensions are switched to calculate the scale factor
        let widthRatio = windowFrame.size.width / CGFloat(DefaultStageSize.height)
        let heightRatio = windowFrame.size.height / CGFloat(DefaultStageSize.width)

        return min(widthRatio, heightRatio)
    }

    func getStageFrame() -> CGRect {
        let sWidth = CGFloat(DefaultStageSize.height) * scaleFactor
        let sHeight = CGFloat(DefaultStageSize.width) * scaleFactor

        let sOriginX = (windowFrame.width - sWidth) / 2
        let sOriginY = (windowFrame.height - sHeight) / 2

        return CGRect(x: sOriginX, y: sOriginY, width: sWidth, height: sHeight)
    }

    func getFrame(location: StageLocation) -> CGRect {

        // Since OSX is always landscape, coordinates are switched
        let xTrns = location.y
        let yTrns = location.x
        let newLocation = StageLocation(x: xTrns, y: yTrns)

        let originX = windowFrame.origin.x + CGFloat(newLocation.x) * scaleFactor
        let originY = windowFrame.origin.y + CGFloat(newLocation.y) * scaleFactor
        let origin = CGPoint(x: originX, y: originY)
        let size = CGSize(width: scaleFactor, height: scaleFactor)

        return CGRect(origin: origin, size: size)
    }

    func getDirection(direction: Direction) -> Direction {
        switch direction {
        case .Up, .Down:
            return Direction.inversedDirection(direction)
        case .Left, .Right:
            let reversed = Direction.reversedDirection(direction)
            return Direction.inversedDirection(reversed)
        case .Unknown:
            assertionFailure("Unknown direction passed in")
        }
    }

    func getOriginalDirection(direction: Direction) -> Direction {
        return .Up
    }
}