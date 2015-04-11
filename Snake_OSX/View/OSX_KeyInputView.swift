//
//  OSX_KeyInputView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit

class OSX_KeyInputView: NSView {
    
    var delegate: KeyInputViewDelegate?
    
    override func keyDown(theEvent: NSEvent) {
        if let key = theEvent.charactersIgnoringModifiers{
            delegate?.processKeyInput(key)
        }
    }

    override var acceptsFirstResponder: Bool {
        return true
    }
    
}

protocol KeyInputViewDelegate {
    func processKeyInput(key: String)
}
