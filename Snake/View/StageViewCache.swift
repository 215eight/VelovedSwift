//
//  StageViewCache.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

struct StageViewCache<T: StageElementView> {

    private var stageSubviews = [String: [String: T]]()
    private let viewTransform: StageViewTransform

    init(viewTransform: StageViewTransform) {
        self.viewTransform = viewTransform
    }
    
    func getStageElementView(element: StageElement) -> T? {
        let elementType = element.dynamicType.className()

        if let stageElementViews = stageSubviews[elementType] {
            if let stageElementView = stageElementViews[element.elementID] {
                return stageElementView
            }
        }
        return nil
    }

    mutating func setStageElementView(elementView: T, forElement element: StageElement) {

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
            var stageElementViews = [String: T]()
            stageElementViews[element.elementID] = elementView
            stageSubviews[elementType] = stageElementViews
        }

    }

    mutating func purgeCache() {
        stageSubviews.removeAll(keepCapacity: false)
    }

}