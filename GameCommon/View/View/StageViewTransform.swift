//
//  StageViewTransform.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/7/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

import Foundation

public enum StageOrientation: Printable {
    case Portrait
    case LandscapeRight
    case LandscapeLeft
    case PortraitUpsideDown
    case Unknow

    public var description: String {
        switch self {
        case .Portrait:
            return "Portrait"
        case .LandscapeRight:
            return "Landscape Right"
        case .LandscapeLeft:
            return "Landscape Left"
        case .PortraitUpsideDown:
            return "Portrait Upside Down"
        case .Unknow:
            return "Unknown"
        }
    }
}

public protocol DeviceStageViewTransform {
    
    func getStageFrame() -> CGRect
    func getFrame(location: StageLocation) -> CGRect
    func getDirection(direction: Direction) -> Direction
    func getOriginalDirection(direction: Direction) -> Direction
    
}

public struct StageViewTransform {
    
    var deviceTransform: DeviceStageViewTransform
    
    public init(deviceTransform: DeviceStageViewTransform) {
        self.deviceTransform = deviceTransform
    }

    public func getStageFrame() -> CGRect {
        return deviceTransform.getStageFrame()
    }
    
    public func getFrame(location: StageLocation) -> CGRect {
        return deviceTransform.getFrame(location)
    }
    
    
    public func getDirection(direction: Direction) -> Direction {
        return deviceTransform.getDirection(direction)
    }

    public func getOriginalDirection(direction: Direction) -> Direction {
        return deviceTransform.getOriginalDirection(direction)
    }
}