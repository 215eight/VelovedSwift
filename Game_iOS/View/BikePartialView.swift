//
//  BikePartialView.swift
//  BikeView
//
//  Created by PartyMan on 6/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class BikePartialView: UIView {

    var path = UIBezierPath()

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

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        assertionFailure("")
    }

    func configureGeometryDimensions() {
        tireOffset = bounds.size.width * 181818182 / 1000000000
        tireRadius = bounds.size.width * 1 / 3
        halfWheelbase = bounds.size.width - tireRadius - tireOffset
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

    func configureGeometryJunctionPoints() {
        frontTireOrigin = CGPoint(x: bounds.size.width - tireOffset - tireRadius, y: bounds.size.height - tireRadius)
        backTireOrigin = CGPoint(x: tireOffset + tireRadius, y: bounds.size.height - tireRadius)
        bottomBracketCenter = calculateBottomBracketCenter()
        seatTubeTopJunction = calculateSeatTubeTopJunction()
        seatPostTopJunction = calculateSeatPostTopJunction()
        forkCrownJunction = calculateForkCrownJunction()
        headTubeTopJunction = calculateHeadTubeTopJunction()
    }

    func drawViewBorder() {
        let path = UIBezierPath()
        path.lineWidth = 0.5
        UIColor.lightGrayColor().setStroke()
        let vertex1 = CGPoint(x: (bounds.origin.x + bounds.size.width),
            y: bounds.origin.y)
        let vertex2 = CGPoint(x: (bounds.origin.x + bounds.size.width),
            y: (bounds.origin.y + bounds.size.height))
        let vertex3 = CGPoint(x: bounds.origin.x,
            y: (bounds.origin.y + bounds.size.height))
        path.moveToPoint(bounds.origin)
        path.addLineToPoint(vertex1)
        path.addLineToPoint(vertex2)
        path.addLineToPoint(vertex3)
        path.closePath()
        path.stroke()
        UIColor.blackColor().setStroke()
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
    func degree2radian(degree: CGFloat) -> CGFloat {
        return CGFloat(M_PI) * degree / 180
    }
}
