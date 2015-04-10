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
    
    func getStageFrame() -> CGRect
    func getFrame(location: StageLocation) -> CGRect
    func getDirection(direction: Direction) -> Direction
    
}

import UIKit

struct StageViewTransform {
    
    var deviceTransform: DeviceStageViewTransform
    
    init(deviceTransform: DeviceStageViewTransform) {
        self.deviceTransform = deviceTransform
    }

    func getStageFrame() -> CGRect {
        return deviceTransform.getStageFrame()
    }
    
    func getFrame(location: StageLocation) -> CGRect {
        return deviceTransform.getFrame(location)
    }
    
    
    func getDirection(direction: Direction) -> Direction {
        return deviceTransform.getDirection(direction)
    }
}