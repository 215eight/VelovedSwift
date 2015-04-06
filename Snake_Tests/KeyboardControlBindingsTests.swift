//
//  KeyBindingsTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class KeyboardControlBindingsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testKeyBindings() {
        var keyBindings = KeyboardControlBindings()
        let binding1 = keyBindings.next()
        let binding2 = keyBindings.next()
        let binding3 = keyBindings.next()
        let binding4 = keyBindings.next()
        
        XCTAssertEqual(Array(binding1!.keys), ["s", "a", "w", "d"], "First binding contains a,d,w,s keys")
        XCTAssertEqual(Array(binding2!.keys), ["j", "g", "y", "h"], "Second binding contains g,j,y,h keys")
        XCTAssertEqual(Array(binding3!.keys), [";", "l", "'", "p"], "Third binding contains l,',p,; keys")
        XCTAssertTrue(binding4 == nil, "KeyboardControlBindings only has three binidngs")
    }
}