//
//  StageViewCache.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public struct StageViewLog {

    private var stageViews = [String: [String: StageElementView]]()
    private let viewTransform: StageViewTransform

    public init(viewTransform: StageViewTransform) {
        self.viewTransform = viewTransform
    }
    
    public func getStageElementView(element: StageElement) -> StageElementView? {
        let elementType = element.dynamicType.elementName

        if let stageElementViews = stageViews[elementType] {
            if let stageElementView = stageElementViews[element.elementID] {
                return stageElementView
            }
        }
        return nil
    }

    public mutating func setStageElementView(elementView: StageElementView, forElement element: StageElement) {

        let elementType = element.dynamicType.elementName
        if let stageElementViews = stageViews[elementType] {
            if let stageElementView = stageElementViews[element.elementID] {
                stageViews[elementType]![element.elementID] = elementView
            }else {
                var _stageElementViews = stageElementViews
                _stageElementViews[element.elementID] = elementView
                stageViews[elementType] = _stageElementViews
            }
        }else {
            var stageElementViews = [String: StageElementView]()
            stageElementViews[element.elementID] = elementView
            stageViews[elementType] = stageElementViews
        }

    }

    public mutating func purgeLog() {
        stageViews.removeAll(keepCapacity: false)
    }

}