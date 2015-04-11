//
//  iOS_StageViewTransformMock.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/8/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

protocol DeviceStageViewTransformMock: DeviceStageViewTransform {

    var scaleFactor: CGFloat { get set }
    var currentOrientation: StageOrientation { get set }
    var windowSize: CGSize { get set }
}

protocol iOS_DeviceStageViewTransformMock: DeviceStageViewTransformMock {
    init(deviceSVT: iOS_StageViewTransform)
}

struct iOS_StageViewTransformMock: iOS_DeviceStageViewTransformMock {
    
    let deviceSVT: iOS_StageViewTransform
    
    var scaleFactor: CGFloat = 0.0
    var currentOrientation = StageOrientation.Unknow
    var windowSize: CGSize = CGSizeZero {
        didSet {
            scaleFactor = deviceSVT.calculateScaleFactor(windowSize)
        }
    }
    
    init(deviceSVT: iOS_StageViewTransform) {
        self.deviceSVT = deviceSVT
    }
    
    func getStageFrame() -> CGRect {
        return deviceSVT.getStageFrame(windowSize, scaleFactor: scaleFactor, orientation: currentOrientation)
    }
    
    func getFrame(location: StageLocation) -> CGRect {
        return deviceSVT.getFrame(location, orientation: currentOrientation, scaleFactor: scaleFactor)
    }
    
    func getDirection(direction: Direction) -> Direction {
        return deviceSVT.getDirection(direction, orientation: currentOrientation)
    }
}