//
//  MPCGamePlayer_OSXTests.swift
//  SnakeSwift
//
//  Created by PartyMan on 5/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import SnakeCommon

class MPCGamePlayer_OSXTests: XCTestCase {

    override func setUp() {
        super.setUp()
        MPCGamePlayer_OSX.deleteUniqueIDList()
    }

    override func tearDown() {
        MPCGamePlayer_OSX.deleteUniqueIDList()
        super.tearDown()
    }

    func testReuseUniqueIdOnInit() {
        var foo : MPCGamePlayer_OSX?
        var newFoo: NSUUID!
        var fooId: String

        var bar : MPCGamePlayer_OSX?
        var barId: String

        XCTAssertTrue(MPCGamePlayer_OSX.uniqueIDList().isEmpty);

        foo = MPCGamePlayer_OSX()
        fooId = foo!.uniqueID.UUIDString
        XCTAssertEqual(MPCGamePlayer_OSX.uniqueIDList().count, 1, "id list should contain 1 ids")
        XCTAssertEqual(MPCGamePlayer_OSX.uniqueIDList()[foo!.uniqueID]!, 1, "id list should contain 1 ids")

        bar = MPCGamePlayer_OSX()
        barId = bar!.uniqueID.UUIDString
        XCTAssertEqual(MPCGamePlayer_OSX.uniqueIDList().count, 2, "id list should contain 2 ids")

        foo = nil

        newFoo = MPCGamePlayer_OSX().uniqueID
        XCTAssertEqual(fooId, newFoo.UUIDString, "foo should reuse an id")
        XCTAssertNotEqual(fooId, barId, "bar should not use foos id")
    }

}
