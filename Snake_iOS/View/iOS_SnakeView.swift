//
//  iOS_SnakeView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import SnakeCommon

struct iOS_SnakeView: StageElementView {

    var views = [AnyObject]()

    init(element: StageElement, transform: StageViewTransform) {
        views = initViews(element, transform: transform)
    }

    private func initViews(element: StageElement, transform: StageViewTransform) -> [AnyObject] {

        var views = [UIView]()

        var index = 0
        for location in element.locations {
            let viewFrame = transform.getFrame(location)
            let view = getView(viewFrame)
            view.backgroundColor = getViewColor(element)

            let label = UILabel(frame: view.bounds)
            label.text = String(format: "%i", arguments: [index++])
            view.addSubview(label)

            views.append(view)
        }
        return views
    }

    private func getView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        return view
    }

    private func getViewColor(element: StageElement) -> UIColor {
        if let snake = element as? Snake {
            switch snake.type {
            case .Solid:
                return UIColor.greenColor()
            case .Squared:
                return UIColor.blueColor()
            case .Dots:
                return UIColor.cyanColor()
            case .Stripes:
                return UIColor.magentaColor()
            default:
                return UIColor.blackColor()
            }
        } else {
            return UIColor.blackColor()
        }
    }
}
