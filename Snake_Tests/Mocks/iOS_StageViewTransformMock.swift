//
//  iOS_StageViewTransformMock.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/8/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

struct iOS_StageViewTransformMock: DeviceStageViewTransform {
    
    var svt: iOS_StageViewTransform
    var testOrientation: StageOrientation = StageOrientation.Portrait
    var testWindowSize: CGSize = CGSizeZero
    
    init(svt: iOS_StageViewTransform) {
        self.svt = svt
    }
    
    var currentOrientation: StageOrientation {
        return testOrientation
    }
    
    var windowSize: CGSize {
        return testWindowSize
    }
    
    func calculateScaleFactor() -> CGFloat {
        return svt.calculateScaleFactor()
    }
    
    func calculateStageFrame(scaleFactor: CGFloat) -> CGRect {
        return svt.calculateStageFrame(scaleFactor, orientation: currentOrientation)
    }
    
    func getFrame(location: StageLocation, scaleFactor: CGFloat) -> CGRect {
        return svt.getFrame(location, scaleFactor: scaleFactor, orientation: currentOrientation)
    }
    func getDirection(direction: Direction) -> Direction {
        return svt.getDirection(direction, orientation: currentOrientation)
    }
}