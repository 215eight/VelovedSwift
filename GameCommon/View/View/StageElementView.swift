//
//  StageElementView.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

public protocol StageElementView {
    var views: [AnyObject] { get }
    init(element: StageElement, transform: StageViewTransform)
}