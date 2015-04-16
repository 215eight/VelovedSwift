//
//  OSX_StageElementViewFactory.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import AppKit


struct OSX_StageElementViewFactory: ConcreteStageElementViewFactory {

    func stageElementView(forElement element: StageElement, transform: StageViewTransform) -> StageElementView {

        let elementType = element.dynamicType.className()

        switch elementType {
        case Obstacle.className():
            return OSX_ObstacleView(element: element, transform: transform)
        case Apple.className():
            return OSX_AppleView(element: element, transform: transform)
        case Snake.className():
            return OSX_SnakeView(element: element, transform: transform)
        default:
            return OSX_ObstacleView(element: element, transform: transform)
        }
    }
}