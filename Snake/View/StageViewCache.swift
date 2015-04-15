//
//  StageViewCache.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

struct StageViewCache {

    private var stageSubviews = [String: [String: StageElementView]]()
    private let viewTransform: StageViewTransform

    init(viewTransform: StageViewTransform) {
        self.viewTransform = viewTransform
    }
    
    func getStageElementView(element: StageElement) -> StageElementView? {
        let elementType = element.dynamicType.className()

        if let stageElementViews = stageSubviews[elementType] {
            if let stageElementView = stageElementViews[element.elementID] {
                return stageElementView
            }
        }
        return nil
    }

    mutating func setStageElementView(elementView: StageElementView, forElement element: StageElement) {

        let elementType = element.dynamicType.className()
        if let stageElementViews = stageSubviews[elementType] {
            if let stageElementView = stageElementViews[element.elementID] {
                stageSubviews[elementType]![element.elementID] = elementView
            }else {
                var _stageElementViews = stageElementViews
                _stageElementViews[element.elementID] = elementView
                stageSubviews[elementType] = _stageElementViews
            }
        }else {
            var stageElementViews = [String: StageElementView]()
            stageElementViews[element.elementID] = elementView
            stageSubviews[elementType] = stageElementViews
        }

    }

}