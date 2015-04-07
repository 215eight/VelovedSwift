//
//  KeyInputView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class KeyInputView: UIView, UIKeyInput {
    
    var delegate: KeyInputViewDelegate?
    
    func hasText() -> Bool {
        return false
    }
    
    func insertText(text: String) {
        if delegate != nil {
            delegate?.processKeyInput(text)
        }
    }
    
    func deleteBackward() {
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
}

protocol KeyInputViewDelegate {
    func processKeyInput(key: String)
}
