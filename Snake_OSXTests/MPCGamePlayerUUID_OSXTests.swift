//
//  MPCGamePlayerUUID_OSXTests.swift
//  SnakeSwift
//
//  Created by PartyMan on 5/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import SnakeCommon

class MPCGamePlayerUUID_OSXTests: XCTestCase {

    override func setUp() {
        super.setUp()
        MPCGamePlayerUUID_OSX.deleteUniqueIDList()
    }

    override func tearDown() {
        MPCGamePlayerUUID_OSX.deleteUniqueIDList()
        super.tearDown()
    }

    func testReuseUniqueIdOnInit() {
        var foo : MPCGamePlayerUUID_OSX?
        var newFoo: NSUUID!
        var fooId: String

        var bar : MPCGamePlayerUUID_OSX?
        var barId: String

        XCTAssertTrue(MPCGamePlayerUUID_OSX.uniqueIDList().isEmpty);

        foo = MPCGamePlayerUUID_OSX()
        fooId = foo!.uniqueID.UUIDString
        XCTAssertEqual(MPCGamePlayerUUID_OSX.uniqueIDList().count, 1, "id list should contain 1 ids")
        XCTAssertEqual(MPCGamePlayerUUID_OSX.uniqueIDList()[foo!.uniqueID]!, 1, "id list should contain 1 ids")

        bar = MPCGamePlayerUUID_OSX()
        barId = bar!.uniqueID.UUIDString
        XCTAssertEqual(MPCGamePlayerUUID_OSX.uniqueIDList().count, 2, "id list should contain 2 ids")

        foo = nil

        newFoo = MPCGamePlayerUUID_OSX().uniqueID
        XCTAssertEqual(fooId, newFoo.UUIDString, "foo should reuse an id")
        XCTAssertNotEqual(fooId, barId, "bar should not use foos id")
    }

}
