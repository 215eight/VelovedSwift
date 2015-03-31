//
//  main.swift
//  Snake_XTerm
//
//  Created by eandrade21 on 3/30/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

func CharacterUnicodeValue(char:String) -> UInt32 {
    
    var unicodeValue : UInt32?
    precondition(countElements(char) == 1, "Char parameter must be of a single character")
    unicodeValue = map(char.unicodeScalars){ $0.value }.first
    return unicodeValue!
}

extension String{
    func CString() -> UnsafePointer<Int8> {
        return (self as NSString).UTF8String
    }
}

//Init Game Controller
//let gameController = SnakeGameController()
//gameController.startGame()

