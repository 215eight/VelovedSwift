//
//  iOS_PlayerView.swift
//  VelovedGame
//
//  Created by eandrade21 on 3/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

struct iOS_PlayerView: StageElementView {

    var views = [AnyObject]()

    init(element: StageElement, transform: StageViewTransform) {
        views = initViews(element, transform: transform)
    }

    private func initViews(element: StageElement, transform: StageViewTransform) -> [AnyObject] {

        var views = [UIView]()

        for (bodyPart, location) in enumerate(element.locations) {
            let viewFrame = transform.getFrame(location)
            if let player = element as? Player {
                let originalOldDirection = transform.getOriginalDirection(player.oldDirection)
                let originalNewDirection = transform.getOriginalDirection(player.direction)
                let view = getView(bodyPart, frame: viewFrame, oldDirection: originalOldDirection, newDirection: originalNewDirection)
                view.backgroundColor = getViewColor(element)
                views.append(view)
            }

        }
        return views
    }

    private func getView(bodyPart: Int, frame: CGRect, oldDirection: Direction, newDirection: Direction) -> UIView {
        switch bodyPart {
        case 0:
            return BikeFrontView(frame: frame,
                oldDirection: oldDirection,
                newDirection: newDirection)
        case 1:
            return BikeRearView(frame: frame,
                oldDirection: oldDirection,
                newDirection: newDirection)
        default:
            let view = UIView(frame: frame)
            return view
        }
    }

    private func getViewColor(element: StageElement) -> UIColor {
        if let player = element as? Player {
            switch player.type {
            case .Solid:
                return blueColor
            case .Squared:
                return greenColor
            case .Dots:
                return orangeColor
            case .Stripes:
                return pinkColor
            default:
                return yellowColor
            }
        } else {
            return UIColor.blackColor()
        }
    }
}
