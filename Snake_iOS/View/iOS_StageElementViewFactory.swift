//
//  iOS_StageElementViewFactory.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import SnakeCommon

struct iOS_StageElementViewFactory: ConcreteStageElementViewFactory {

    func stageElementView(forElement element: StageElement, transform: StageViewTransform) -> StageElementView {

        if let _obstacle = element as? Obstacle {
            return iOS_ObstacleView(element: _obstacle, transform: transform)
        } else if let _apple = element as? Apple {
            return iOS_AppleView(element: _apple, transform: transform)
        } else if let _snake = element as? Snake {
            return iOS_SnakeView(element: _snake, transform: transform)
        } else {
            println("Warning: Trying to create a view for an unknown stage element")
            return iOS_ObstacleView(element: element, transform: transform)
        }
    }
}
