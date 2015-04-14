//
//  OSX_StageViewTransform.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

struct OSX_StageViewTransform: DeviceStageViewTransform {

    private var scaleFactor: CGFloat!

    private var currentOrientation: StageOrientation = .LandscapeLeft

    private var windowFrame: CGRect

    init(frame: CGRect) {
        windowFrame = frame
        scaleFactor = calculateScaleFactor()
    }

    func calculateScaleFactor() -> CGFloat {
        //DefaultStageSize dimensions are based on a portrait orientaion
        //Since OSX is always landscape, dimensions are switched
        let widthRatio = windowFrame.size.width / CGFloat(DefaultStageSize.height)
        let heightRatio = windowFrame.size.height / CGFloat(DefaultStageSize.width)

        return min(widthRatio, heightRatio)
    }

    func getStageFrame() -> CGRect {
        return windowFrame
    }

    func getFrame(location: StageLocation) -> CGRect {

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
        return direction
    }
}