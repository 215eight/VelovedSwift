//
//  OSX_StageElementViewFactory.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import SnakeCommon


struct OSX_StageElementViewFactory: ConcreteStageElementViewFactory {

    func stageElementView(forElement element: StageElement, transform: StageViewTransform) -> StageElementView {

        let elementType = element.dynamicType.getClassName()

        switch elementType {
        case Obstacle.getClassName():
            return OSX_ObstacleView(element: element, transform: transform)
        case Apple.getClassName():
            return OSX_AppleView(element: element, transform: transform)
        case Snake.getClassName():
            return OSX_SnakeView(element: element, transform: transform)
        default:
            return OSX_ObstacleView(element: element, transform: transform)
        }
    }
}