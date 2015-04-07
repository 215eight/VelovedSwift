//
//  StageView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class StageView: UIView {

    var elementsSubviews = [String: [String: [UIView]]]()
    
    let viewTransform: StageViewTransform
    
    init(frame: CGRect, viewTransform: StageViewTransform) {
        self.viewTransform = viewTransform
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    deinit {
        elementsSubviews.removeAll(keepCapacity: false)
    }
    
    func drawStage() {
        frame = viewTransform.stageFrame
    }
    
    func drawElementsInStage(stage: Stage) {
        
        for elements in stage.elements.values {
            for element in elements {
                drawElement(element)
            }
        }
    }
    
    func drawElement(element: StageElement) {
        
        let elementType = element.dynamicType.className()
        
        if var elements = elementsSubviews[elementType] {
            if let elementViews = elements[element.elementID] {
                elementViews.map(){ $0.removeFromSuperview() }
                
                var newViews = getViewsForElement(element)
                newViews.map() { self.addSubview($0) }
                
                elements[element.elementID] = newViews
                elementsSubviews[elementType] = elements
            } else {
                var newViews = getViewsForElement(element)
                newViews.map() { self.addSubview($0) }
                elementsSubviews[elementType]![element.elementID] = newViews
            }
        } else {
            var newViews = getViewsForElement(element)
            newViews.map() { self.addSubview($0) }
            var newElements = [String: [UIView]]()
            newElements[element.elementID] = newViews
            elementsSubviews[elementType] = newElements
        }
    }
    
    func getViewsForElement(element: StageElement) -> [UIView] {
        
        var views = [UIView]()
        
        let elementType = element.dynamicType.className()
        
        for elementLocation in element.locations {
            let elementFrame = viewTransform.getFrame(elementLocation)
            var elementView: UIView
            
            // TODO: Extract class creation to a factory
            switch elementType {
            case "Obstacle":
                elementView = ObstacleView(frame: elementFrame)
            //case "Tunnel":
            //    elementView = TunnelView(frame: elementFrame)
            case "Apple":
                elementView = AppleView(frame: elementFrame)
            case "Snake":
                let snake = element as Snake
                elementView = SnakeView(frame: elementFrame, type: snake.type)
            default:
                elementView = ObstacleView(frame: elementFrame)
            }
            
            views.append(elementView)
        }
        
        return views
    }
}
