//
//  iOS_StageElementViewFactory.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

//import Foundation
//import UIKit
import SnakeCommon

struct iOS_StageElementViewFactory: ConcreteStageElementViewFactory {

    func stageElementView(forElement element: StageElement, transform: StageViewTransform) -> StageElementView {

        let elementType = element.dynamicType.getClassName()

        switch elementType {
        case Obstacle.getClassName():
            return iOS_ObstacleView(element: element, transform: transform)
        case Apple.getClassName():
            return iOS_AppleView(element: element, transform: transform)
        case Snake.getClassName():
            return iOS_SnakeView(element: element, transform: transform)
        default:
            return iOS_ObstacleView(element: element, transform: transform)
        }
    }
}
