//
//  iOS_StageElementViewFactory.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import VelovedCommon

struct iOS_StageElementViewFactory: ConcreteStageElementViewFactory {

    func stageElementView(forElement element: StageElement, transform: StageViewTransform) -> StageElementView {

        if let _obstacle = element as? Obstacle {
            return iOS_ObstacleView(element: _obstacle, transform: transform)
        } else if let _target = element as? Target {
            return iOS_TargetView(element: _target, transform: transform)
        } else if let _player = element as? Player {
            return iOS_PlayerView(element: _player, transform: transform)
        } else {
            println("Warning: Trying to create a view for an unknown stage element")
            return iOS_ObstacleView(element: element, transform: transform)
        }
    }
}
