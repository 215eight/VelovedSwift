//
//  BikeFrontView.swift
//  BikeView
//
//  Created by eandrade21 on 6/10/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import GameCommon

class BikeFrontView: BikePartialView {

    init(frame: CGRect, oldDirection: Direction, newDirection: Direction) {
        super.init(frame: frame)
//        let newSize = CGSize(width: frame.width / 2, height: frame.width / 2)
//        let newOrigin = CGPoint(x: frame.width / 2, y: frame.height / 2 - frame.width / 4)
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

        drawFrontTire()
        drawHeadTubeAndFork()
        drawTopTube()
        drawDownTube()
        drawStemAndHandlebars()

        path.applyTransform(pathTransform)
        path.lineWidth = 0.5
        path.stroke()

        CGContextRestoreGState(context)
    }

    func drawFrontTire() {
        let vertex1 = CGPoint(x: (frontTireOrigin.x + tireRadius), y: frontTireOrigin.y)
        path.moveToPoint(vertex1)
        path.addArcWithCenter(frontTireOrigin, radius: tireRadius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        path.addArcWithCenter(frontTireOrigin, radius: tireRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_2_PI), clockwise: true)
    }

    func drawHeadTubeAndFork() {
        path.moveToPoint(frontTireOrigin)
        path.addLineToPoint(headTubeTopJunction)
    }

    func drawTopTube() {
        path.moveToPoint(headTubeTopJunction)
        path.addLineToPoint(seatTubeTopJunction)
    }

    func drawDownTube() {
        path.moveToPoint(forkCrownJunction)
        path.addLineToPoint(bottomBracketCenter)
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

    override func calculateBottomBracketCenter() -> CGPoint {
        return CGPoint(x: -halfWheelbase + sqrt(pow(chainStayLength, 2) + pow(bottomBracketDrop, 2)),
            y: bounds.size.height - tireRadius + bottomBracketDrop)
    }

    override func calculateForkCrownJunction() -> CGPoint {
        let vertexX = frontTireOrigin.x - (forkLength * sin(degree2radian(90 - headTubeAngle)))
        let vertexY = frontTireOrigin.y - (forkLength * cos(degree2radian(90 - headTubeAngle)))
        return CGPoint(x: vertexX, y: vertexY)
    }
}
