//
//  OSX_StageView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit

class OSX_StageView : NSView {

    let viewTransform: StageViewTransform
    var stageViewCache: StageViewCache
    let viewFactory: ConcreteStageElementViewFactory

    override init(frame: CGRect) {
        let osx_transform = OSX_StageViewTransform(frame: frame)
        viewTransform = StageViewTransform(deviceTransform: osx_transform)
        stageViewCache = StageViewCache(viewTransform: viewTransform)
        viewFactory = AbstractStageElementViewFactory.getStageElementViewFactory(StageElementViewFactoryType.OSX_StageElementViewFactory)
        super.init(frame: frame)
    }

    deinit {
        println("Deinit")
        stageViewCache.purgeCache()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawElement(element: StageElement) {

        if let stageElementView = stageViewCache.getStageElementView(element) {
            stageElementView.subviews.map() { $0.removeFromSuperview() }
        }

        let newStageElementView = viewFactory.stageElementView(forElement: element, transform: viewTransform)
        newStageElementView.subviews.map() { self.addSubview( $0 as NSView ) }

        stageViewCache.setStageElementView(newStageElementView, forElement: element)
    }
}