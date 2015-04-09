//
//  StageViewTransform.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/7/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

enum StageOrientation {
    case Portrait
    case LandscapeRight
    case LandscapeLeft
    case PortraitUpsideDown
    case Unknow
}

protocol DeviceStageViewTransform {
    
    var currentOrientation: StageOrientation { get }
    var windowSize: CGSize { get }
    
    func calculateScaleFactor() -> CGFloat
    func calculateStageFrame(scaleFactor: CGFloat) -> CGRect
    
    func getFrame(location: StageLocation, scaleFactor: CGFloat) -> CGRect
    func getDirection(direction: Direction) -> Direction
    
}

import UIKit

struct StageViewTransform {
    
    var deviceTransform: DeviceStageViewTransform
    
    var windowSize: CGSize {
        return deviceTransform.windowSize
    }
    
    var scaleFactor: CGFloat {
        return deviceTransform.calculateScaleFactor()
    }
    
    var stageFrame: CGRect {
        return deviceTransform.calculateStageFrame(scaleFactor)
    }
    
    init(deviceTransform: DeviceStageViewTransform) {
        self.deviceTransform = deviceTransform
    }
    
    func getFrame(location: StageLocation) -> CGRect {
        return deviceTransform.getFrame(location, scaleFactor: scaleFactor)
    }
    
    
    func getDirection(direction: Direction) -> Direction {
        return deviceTransform.getDirection(direction)
    }
}