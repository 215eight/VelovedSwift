//
//  StageElementView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

protocol StageElementView {

    var subviews: [AnyObject] { get }

    class func getStageElementView(element: StageElement, transform: StageViewTransform) -> StageElementView
}