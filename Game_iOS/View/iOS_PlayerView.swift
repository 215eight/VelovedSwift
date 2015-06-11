//
//  iOS_PlayerView.swift
//  GameSwift
//
//  Created by eandrade21 on 3/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import GameCommon

struct iOS_PlayerView: StageElementView {

    var views = [AnyObject]()

    init(element: StageElement, transform: StageViewTransform) {
        views = initViews(element, transform: transform)
    }

    private func initViews(element: StageElement, transform: StageViewTransform) -> [AnyObject] {

        var views = [UIView]()

        for (index, location) in enumerate(element.locations) {
            let viewFrame = transform.getFrame(location)
            let view = getView(index, frame: viewFrame, element: element)

            views.append(view)
        }
        return views
    }

    private func getView(index: Int, frame: CGRect, element: StageElement) -> UIView {
        switch index {
        case 0:
            return BikeFrontView(frame: frame)
        case 1:
            return BikeRearView(frame: frame)
        default:
            let view = UIView(frame: frame)
            view.backgroundColor = getViewColor(element)
            return view
        }
    }

    private func getViewColor(element: StageElement) -> UIColor {
        if let player = element as? Player {
            switch player.type {
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
