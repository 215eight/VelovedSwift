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
        let controller1 = keyBindings.controllers.next()
        let controller2 = keyBindings.controllers.next()
        let controller3 = keyBindings.controllers.next()
        let controller4 = keyBindings.controllers.next()
        
        XCTAssertEqual(controller1!, ["s", "a", "w", "d"], "First controller contains a,d,w,s keys")
        XCTAssertEqual(controller2!, ["j", "g", "y", "h"], "Second controller contains g,j,y,h keys")
        XCTAssertEqual(controller3!, [";", "l", "'", "p"], "Third controller contains l,',p,; keys")
        XCTAssertTrue(controller4 == nil, "KeyboardControlBindings only has three controllers")
    }
    
    func testGetDirectionForKey() {
        var keyBindings = KeyboardControlBindings()
        
        XCTAssertTrue(keyBindings.getDirectionForKey("x") == nil, "X has no direction asosciated to itself")
        XCTAssertTrue(keyBindings.getDirectionForKey("s") == Direction.Down, "s is associated to Down")
    }
}