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

        for (bodyPart, location) in enumerate(element.locations) {
            let viewFrame = transform.getFrame(location)
            if let player = element as? Player {
                let playerOldDirection = transform.getDirection(player.oldDirection)
                let playerNewDirection = transform.getDirection(player.direction)
//                println("Orientation: \(UIDevice.currentDevice().orientation.rawValue)")
//                println("Player View Original - Old: \(player.oldDirection) - Dir: \(player.direction)")
//                println("Player View Current  - Old: \(playerOldDirection) - Dir: \(playerNewDirection)")
                let view = getView(bodyPart, frame: viewFrame, oldDirection: playerOldDirection, newDirection: playerNewDirection)
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
