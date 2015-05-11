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

        if let _obstacle = element as? Obstacle {
            return OSX_ObstacleView(element: _obstacle, transform: transform)
        } else if let _apple = element as? Apple {
            return OSX_AppleView(element: _apple, transform: transform)
        } else if let _snake = element as? Snake {
            return OSX_SnakeView(element: _snake, transform: transform)
        } else {
            println("Warning: Trying to create a view for an unknown stage element")
            return OSX_ObstacleView(element: element, transform: transform)
        }
    }
}