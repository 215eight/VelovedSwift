//
//  iOS_StageElementViewFactory.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import UIKit

struct iOS_StageElementViewFactory: ConcreteStageElementViewFactory {

    func stageElementView(forElement element: StageElement, transform: StageViewTransform) -> StageElementView {

        let elementType = element.dynamicType.className()

        switch elementType {
        case Obstacle.className():
            return iOS_ObstacleView(element: element, transform: transform)
        case Apple.className():
            return iOS_AppleView(element: element, transform: transform)
        case Snake.className():
            return iOS_SnakeView(element: element, transform: transform)
        default:
            return iOS_ObstacleView(element: element, transform: transform)
        }
    }
}
