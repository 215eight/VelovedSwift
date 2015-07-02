//
//  BikePartialView.swift
//  BikeView
//
//  Created by eandrade21 on 6/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

class BikeView: UIView {


    var badgeRadius: CGFloat
    var badgeInset: CGFloat
    var badgeColor: UIColor = UIColor.clearColor()
    var insetFrame: CGRect = CGRectZero

    var path = UIBezierPath()
    var pathTransform = CGAffineTransformIdentity

    // Geometry Dimensions
    var tireOffset: CGFloat = 0
    var tireRadius: CGFloat = 0
    var halfWheelbase: CGFloat = 0
    var chainStayLength: CGFloat = 0
    var bottomBracketDrop: CGFloat = 0
    var seatTubeLength: CGFloat = 0
    var seatTubeAngle: CGFloat = 0
    var seatPostLength: CGFloat = 0
    var headTubeAndForkLength: CGFloat = 0
    var headTubeLength: CGFloat = 0
    var forkLength: CGFloat = 0
    var headTubeAngle: CGFloat = 0
    var steerTubeLength: CGFloat = 0
    var handlebarsLength: CGFloat = 0

    // Geometry Junction Points
    var frontTireOrigin: CGPoint = CGPointZero
    var backTireOrigin: CGPoint = CGPointZero
    var bottomBracketCenter: CGPoint = CGPointZero
    var seatTubeTopJunction: CGPoint = CGPointZero
    var seatPostTopJunction: CGPoint = CGPointZero
    var forkCrownJunction: CGPoint = CGPointZero
    var headTubeTopJunction: CGPoint = CGPointZero

    init(frame: CGRect, oldDirection: Direction, newDirection: Direction) {
        badgeRadius = 0
        badgeInset = 0

        super.init(frame: frame)

        resizeFrame()

        configureViewTransform(oldDirection: oldDirection, newDirection: newDirection)
        configureGeometryDimensions()
        configureGeometryJunctionPoints()
    }

    override init(frame: CGRect) {
        badgeRadius = 0
        badgeInset = 0
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resizeFrame() {
        insetFrame = CGRectInset(bounds, badgeInset, badgeInset)
    }

    func configureViewTransform(#oldDirection: Direction, newDirection: Direction) {

        switch newDirection {
        case .Up:
            var rotationAngle: CGFloat = 0
            switch oldDirection {
            case .Right:
                    rotationAngle = -90
                    pathTransform = CGAffineTransformRotate(pathTransform, degree2radian(rotationAngle))
                    pathTransform = CGAffineTransformTranslate(pathTransform, -insetFrame.size.width, 0)

            case .Left:
                    rotationAngle = -90
                    pathTransform = CGAffineTransformMake(-1, 0, 0, 1, insetFrame.size.width, 0)
                    pathTransform = CGAffineTransformRotate(pathTransform, degree2radian(rotationAngle))
                    pathTransform = CGAffineTransformTranslate(pathTransform, -insetFrame.size.width, 0)
            default:
                rotationAngle = -90
                pathTransform = CGAffineTransformRotate(pathTransform, degree2radian(rotationAngle))
                pathTransform = CGAffineTransformTranslate(pathTransform, -insetFrame.size.width, 0)
            }

        case .Down:
            var rotationAngle: CGFloat = 0
            switch oldDirection {
            case .Right:
                    rotationAngle = 90
                    pathTransform = CGAffineTransformRotate(pathTransform, degree2radian(rotationAngle))
                    pathTransform = CGAffineTransformTranslate(pathTransform, 0, -insetFrame.size.height)
            case .Left:
                    rotationAngle = 90
                    pathTransform = CGAffineTransformMake(-1, 0, 0, 1, insetFrame.size.width, 0)
                    pathTransform = CGAffineTransformRotate(pathTransform, degree2radian(rotationAngle))
                    pathTransform = CGAffineTransformTranslate(pathTransform, 0, -insetFrame.size.width)
            default:
                rotationAngle = 90
                pathTransform = CGAffineTransformRotate(pathTransform, degree2radian(rotationAngle))
                pathTransform = CGAffineTransformTranslate(pathTransform, 0, -insetFrame.size.height)
            }
        case .Left:
            pathTransform = CGAffineTransformMake(-1, 0, 0, 1, insetFrame.size.width + badgeInset * 2, 0)
        case .Right:
            pathTransform = CGAffineTransformIdentity
        case .Unknown:
            pathTransform = CGAffineTransformIdentity
        }
    }

    func configureGeometryDimensions() {
        assertionFailure("")
    }

    func configureGeometryJunctionPoints() {
        assertionFailure("")
    }
}

class BikePartialView: BikeView {


    override func configureGeometryDimensions() {
        tireOffset = insetFrame.size.width * 16 / 100
        tireRadius = insetFrame.size.width * 1 / 3
        halfWheelbase = insetFrame.size.width - tireRadius - tireOffset
        chainStayLength = halfWheelbase * 7850 / 10000
        bottomBracketDrop = halfWheelbase * 100300 / 1000000
        seatTubeLength = halfWheelbase * 1163490471 / 1000000000
        seatTubeAngle = 75
        seatPostLength = halfWheelbase * 1 / 5
        headTubeAndForkLength = seatTubeLength - (bottomBracketDrop / sin(degree2radian(75)))
        headTubeLength = headTubeAndForkLength * 1 / 7
        forkLength = headTubeAndForkLength * 6 / 7
        headTubeAngle = 74
        steerTubeLength = halfWheelbase * 1 / 6
        handlebarsLength = halfWheelbase * 1 / 4
    }

    override func configureGeometryJunctionPoints() {
        frontTireOrigin = CGPoint(x: insetFrame.size.width - tireOffset - tireRadius, y: insetFrame.size.height - tireRadius)
        backTireOrigin = CGPoint(x: tireOffset + tireRadius, y: insetFrame.size.height - tireRadius)
        bottomBracketCenter = calculateBottomBracketCenter()
        seatTubeTopJunction = calculateSeatTubeTopJunction()
        seatPostTopJunction = calculateSeatPostTopJunction()
        forkCrownJunction = calculateForkCrownJunction()
        headTubeTopJunction = calculateHeadTubeTopJunction()
    }

    func drawViewBorder() {
        let path = UIBezierPath(rect: bounds)
        path.lineWidth = 0.5
        UIColor.lightGrayColor().setStroke()
        path.fill()
    }

    func calculateBottomBracketCenter() -> CGPoint {
        assertionFailure("Method must be overriden by subclass")
    }

    func calculateSeatTubeTopJunction() -> CGPoint {
        let vertexX = bottomBracketCenter.x - (seatTubeLength * sin(degree2radian(90 - seatTubeAngle)))
        let vertexY = bottomBracketCenter.y - (seatTubeLength * cos(degree2radian(90 - seatTubeAngle)))
        return CGPoint(x: vertexX, y: vertexY)
    }

    func calculateSeatPostTopJunction() -> CGPoint {
        let vertexX = seatTubeTopJunction.x - (seatPostLength * sin(degree2radian(90 - seatTubeAngle)))
        let vertexY = seatTubeTopJunction.y - (seatPostLength * cos(degree2radian(90 - seatTubeAngle)))
        return CGPoint(x: vertexX, y: vertexY)
    }

    func calculateForkCrownJunction() -> CGPoint {
        assertionFailure("Method must be overriden by subclass")
    }

    func calculateHeadTubeTopJunction() -> CGPoint {
        let vertexX = frontTireOrigin.x - (headTubeAndForkLength * sin(degree2radian(90 - headTubeAngle)))
        let vertexY = frontTireOrigin.y - (headTubeAndForkLength * cos(degree2radian(90 - headTubeAngle)))
        return CGPoint(x: vertexX, y: vertexY)
    }

}
