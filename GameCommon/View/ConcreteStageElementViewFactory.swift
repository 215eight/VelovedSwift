//
//  ConcreteStageElementViewFactory.swift
//  GameSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

public protocol ConcreteStageElementViewFactory {
    typealias ElementView
    func stageElementView(#forElement: StageElement, transform: StageViewTransform) -> ElementView
}