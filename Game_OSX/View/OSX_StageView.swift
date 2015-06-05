//
//  OSX_StageView.swift
//  GameSwift
//
//  Created by eandrade21 on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit
import GameCommon

class OSX_StageView : NSView {

    let viewTransform: StageViewTransform
    var stageViewLog: StageViewLog
    let viewFactory: OSX_StageElementViewFactory
    var delegate: InputViewDelegate?

    override init(frame: CGRect) {
        let osx_transform = OSX_StageViewTransform(frame: frame)
        viewTransform = StageViewTransform(deviceTransform: osx_transform)
        stageViewLog = StageViewLog(viewTransform: viewTransform)
        viewFactory = OSX_StageElementViewFactory()

        let _frame = viewTransform.getStageFrame()
        super.init(frame: _frame)
        self.wantsLayer = true
        layer?.backgroundColor = NSColor.whiteColor().CGColor
    }

    deinit {
        delegate = nil
        stageViewLog.purgeLog()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawElement(element: StageElement) {

        if let stageElementView = stageViewLog.getStageElementView(element) {
            stageElementView.views.map() { $0.removeFromSuperview() }
        }

        let newStageElementView = viewFactory.stageElementView(forElement: element, transform: viewTransform)
        newStageElementView.views.map() { self.addSubview($0 as NSView) }

        stageViewLog.setStageElementView(newStageElementView, forElement: element)
    }

    func showModalMessage() {
        let msgView = NSView(frame: bounds)
        msgView.layer?.backgroundColor = NSColor.lightGrayColor().CGColor

        self.addSubview(msgView)
    }
}

extension OSX_StageView {

    override func keyDown(theEvent: NSEvent) {
        if let key = theEvent.charactersIgnoringModifiers{
            delegate?.processKeyInput(key, transform: viewTransform)
        }
    }

    override var acceptsFirstResponder: Bool {
        return true
    }
}


public protocol InputViewDelegate {
    func processKeyInput(key: String, transform: StageViewTransform)
}