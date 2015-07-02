//
//  BikeFullView.swift
//  VelovedGame
//
//  Created by eandrade21 on 6/30/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

class BikeFullView: BikeView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        badgeRadius = 30
        horizontalBadgeInset = 20
        verticalBadgeInset = 10

        resizeFrame()
        configureViewTransform(oldDirection: .Left, newDirection: .Left)
        configureGeometryDimensions()
        configureGeometryJunctionPoints()

        backgroundColor = UIColor.clearColor()

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func resizeFrame() {
        let minFrameSide = min(frame.size.width, frame.size.height)

        let newSize = CGSize(width: minFrameSide, height: minFrameSide)
        let newOrigin = CGPoint(x: (frame.size.width / 2) - (minFrameSide / 2), y: (frame.size.height / 2) - (minFrameSide / 2))
        frame = CGRect(origin: newOrigin, size: newSize)

        super.resizeFrame()
    }

    override func configureGeometryDimensions() {

        tireOffset = horizontalBadgeInset
        tireRadius = insetFrame.size.width * 1 / 5
        let wheelbase = insetFrame.size.width - (tireRadius * 2)
        halfWheelbase = wheelbase / 2
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
        frontTireOrigin = CGPoint(x: tireOffset + insetFrame.size.width - tireRadius, y: verticalBadgeInset + insetFrame.size.height - tireRadius)
        backTireOrigin = CGPoint(x: tireOffset + tireRadius, y: verticalBadgeInset + insetFrame.size.height - tireRadius)
        bottomBracketCenter = calculateBottomBracketCenter()
        seatTubeTopJunction = calculateSeatTubeTopJunction()
        seatPostTopJunction = calculateSeatPostTopJunction()
        forkCrownJunction = calculateForkCrownJunction()
        headTubeTopJunction = calculateHeadTubeTopJunction()
    }

    func calculateBottomBracketCenter() -> CGPoint {
        return CGPoint(x: tireRadius + tireOffset + sqrt(pow(chainStayLength, 2) + pow(bottomBracketDrop, 2)),
            y: verticalBadgeInset + insetFrame.size.height - tireRadius + bottomBracketDrop)
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
        let vertexX = frontTireOrigin.x - (forkLength * sin(degree2radian(90 - headTubeAngle)))
        let vertexY = frontTireOrigin.y - (forkLength * cos(degree2radian(90 - headTubeAngle)))
        return CGPoint(x: vertexX, y: vertexY)
    }

    func calculateHeadTubeTopJunction() -> CGPoint {
        let vertexX = frontTireOrigin.x - (headTubeAndForkLength * sin(degree2radian(90 - headTubeAngle)))
        let vertexY = frontTireOrigin.y - (headTubeAndForkLength * cos(degree2radian(90 - headTubeAngle)))
        return CGPoint(x: vertexX, y: vertexY)
    }

    override func drawRect(rect: CGRect) {

        resizeFrame()
        configureGeometryDimensions()
        configureGeometryJunctionPoints()

        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)

//        drawBadge()
        drawBackTire()
        drawFrontTire()
        drawChainStay()
        drawSeatTube()
        drawSeatStay()
        drawTopTube()
        drawDownTube()
        drawHeadTubeAndFork()
        drawStemAndHandlebars()
        drawSeatPost()
        drawSeat()

        path.applyTransform(pathTransform)
        grayColor.setStroke()
        path.lineWidth = 2
        path.stroke()

        CGContextRestoreGState(context)
    }

    func drawBadge() {
        let badgePath = UIBezierPath(roundedRect: bounds, cornerRadius: badgeRadius)
        badgeColor.setFill()

        badgePath.fill()
    }

    func drawBackTire() {
        let vertex1 = CGPoint(x: (backTireOrigin.x + tireRadius), y: backTireOrigin.y)
        path.moveToPoint(vertex1)
        path.addArcWithCenter(backTireOrigin, radius: tireRadius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        path.addArcWithCenter(backTireOrigin, radius: tireRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_2_PI), clockwise: true)
    }

    func drawFrontTire() {
        let vertex1 = CGPoint(x: (frontTireOrigin.x + tireRadius), y: frontTireOrigin.y)
        path.moveToPoint(vertex1)
        path.addArcWithCenter(frontTireOrigin, radius: tireRadius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        path.addArcWithCenter(frontTireOrigin, radius: tireRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_2_PI), clockwise: true)
    }

    func drawChainStay() {
        path.moveToPoint(backTireOrigin)
        path.addLineToPoint(bottomBracketCenter)
    }

    func drawSeatTube() {
        path.moveToPoint(bottomBracketCenter)
        path.addLineToPoint(seatTubeTopJunction)
    }

    func drawSeatStay() {
        path.moveToPoint(backTireOrigin)
        path.addLineToPoint(seatTubeTopJunction)
    }

    func drawTopTube() {
        path.moveToPoint(seatTubeTopJunction)
        path.addLineToPoint(headTubeTopJunction)
    }

    func drawDownTube() {
        path.moveToPoint(bottomBracketCenter)
        path.addLineToPoint(forkCrownJunction)
    }

    func drawHeadTubeAndFork() {
        path.moveToPoint(frontTireOrigin)
        path.addLineToPoint(headTubeTopJunction)
    }

    func drawStemAndHandlebars() {
        let vertexX = headTubeTopJunction.x - (steerTubeLength * sin(degree2radian(90 - headTubeAngle)))
        let vertexY = headTubeTopJunction.y - (steerTubeLength * cos(degree2radian(90 - headTubeAngle)))
        let vertex = CGPoint(x: vertexX, y: vertexY)

        path.moveToPoint(headTubeTopJunction)
        path.addLineToPoint(vertex)

        let vertex2 = CGPoint(x: vertex.x + handlebarsLength, y: vertex.y)
        path.addLineToPoint(vertex2)
    }

    func drawSeatPost() {
        path.moveToPoint(seatTubeTopJunction)
        path.addLineToPoint(seatPostTopJunction)
    }

    func drawSeat() {
        let vertex1 = CGPoint(x: seatPostTopJunction.x - seatPostLength, y: seatPostTopJunction.y)
        let vertex2 = CGPoint(x: seatPostTopJunction.x + seatPostLength, y: seatPostTopJunction.y)
        path.moveToPoint(vertex1)
        path.addLineToPoint(vertex2)
    }

}
