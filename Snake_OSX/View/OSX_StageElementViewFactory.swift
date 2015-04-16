//
//  OSX_StageElementViewFactory.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import AppKit

extension NSView: StageElementView {}

struct OSX_StageElementViewFactory: ConcreteStageElementViewFactory {

    func stageElementView(forElement element: StageElement, transform: StageViewTransform) -> NSView {

        let elementType = element.dynamicType.className()

        // TODO: Use regular constructor instead of instace method
        switch elementType {
        case Obstacle.className():
            return OSX_ObstacleView.getStageElementView(element, transform: transform)
        case Apple.className():
            return OSX_AppleView.getStageElementView(element, transform: transform)
        case Snake.className():
            return OSX_SnakeView.getStageElementView(element, transform: transform)
        default:
            return OSX_ObstacleView.getStageElementView(element, transform: transform)
        }
    }
}