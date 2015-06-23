//
//  iOS_TargetView.swift
//  GameSwift
//
//  Created by eandrade21 on 3/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import GameCommon

struct iOS_TargetView: StageElementView {

    var views = [AnyObject]()

    init(element: StageElement, transform: StageViewTransform) {
        views = initViews(element, transform: transform)
    }

    private func initViews(element: StageElement, transform: StageViewTransform) -> [AnyObject] {

        var views = [UIView]()

        for location in element.locations {
            let viewFrame = transform.getFrame(location)
            let view = getView(viewFrame)
            views.append(view)
        }
        return views
    }

    private func getView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        let label = UILabel(frame: view.bounds)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(12)
        label.lineBreakMode = NSLineBreakMode.ByClipping
        label.adjustsFontSizeToFitWidth = true
        label.text = "🍄"
        view.addSubview(label)
        return view
    }
}
