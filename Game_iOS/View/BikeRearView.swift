//
//  BikeRearView.swift
//  BikeView
//
//  Created by eandrade21 on 6/10/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import GameCommon

class BikeRearView: BikePartialView {

    init(frame: CGRect, oldDirection: Direction?, newDirection: Direction) {
        super.init(frame: frame)
//        let newSize = CGSize(width: frame.width / 2, height: frame.width / 2)
//        let newOrigin = CGPoint(x: 0, y: frame.height / 2 - frame.width / 4)
//        self.frame = CGRect(origin: newOrigin, size: newSize)
        backgroundColor = UIColor.whiteColor()

        configureViewTransform(oldDirection: oldDirection, newDirection: newDirection)
        configureGeometryDimensions()
        configureGeometryJunctionPoints()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)

        drawBackTire()
        drawChainStay()
        drawSeatTube()
        drawSeatStay()
        drawTopTube()
        drawDownTube()
        drawSeatPost()
        drawSeat()

        path.applyTransform(pathTransform)
        path.lineWidth = 0.5
        path.stroke()

        CGContextRestoreGState(context)
    }

    func drawBackTire() {
        let vertex1 = CGPoint(x: (backTireOrigin.x + tireRadius), y: backTireOrigin.y)
        path.moveToPoint(vertex1)
        path.addArcWithCenter(backTireOrigin, radius: tireRadius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        path.addArcWithCenter(backTireOrigin, radius: tireRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_2_PI), clockwise: true)
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
        let vertex = CGPoint(x: bounds.size.width * 2 - headTubeTopJunction.x, y: seatTubeTopJunction.y)
        path.addLineToPoint(vertex)
    }

    func drawDownTube() {
        path.moveToPoint(bottomBracketCenter)
        path.addLineToPoint(forkCrownJunction)
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

    override func calculateBottomBracketCenter() -> CGPoint {
        return CGPoint(x: tireRadius + tireOffset + sqrt(pow(chainStayLength, 2) + pow(bottomBracketDrop, 2)),
            y: bounds.size.height - tireRadius + bottomBracketDrop)
    }

    override func calculateForkCrownJunction() -> CGPoint {
        let vertexX = bounds.size.width + frontTireOrigin.x - (forkLength * sin(degree2radian(90 - headTubeAngle)))
        let vertexY = frontTireOrigin.y - (forkLength * cos(degree2radian(90 - headTubeAngle)))
        return CGPoint(x: vertexX, y: vertexY)
    }
}
