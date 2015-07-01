//
//  PlayButtonView.swift
//  BikeView
//
//  Created by eandrade21 on 6/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class PlayButtonView: SymbolView {

    override func drawRect(rect: CGRect) {

        let path = UIBezierPath(ovalInRect: bounds)
        grayColor.setFill()
        path.fill()

        let boundsCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = bounds.width * 1 / 3
        let subCO = sin(degree2radian(30)) * radius
        let subCA = cos(degree2radian(30)) * radius

        let vertexA = CGPoint(x: boundsCenter.x - subCO, y: boundsCenter.y - subCA)
        let vertexB = CGPoint(x: boundsCenter.x + radius, y: boundsCenter.y)
        let vertexC = CGPoint(x: boundsCenter.x - subCO, y: boundsCenter.y + subCA)

        let trianglePath = UIBezierPath()
        trianglePath.moveToPoint(vertexA)
        trianglePath.addLineToPoint(vertexB)
        trianglePath.addLineToPoint(vertexC)
        trianglePath.closePath()

        UIColor.whiteColor().setFill()
        trianglePath.fill()

    }
}
