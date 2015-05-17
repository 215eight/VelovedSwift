//
//  MPCGamePlayerOSXTests.swift
//  SnakeSwift
//
//  Created by PartyMan on 5/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest
import SnakeCommon

class MPCGamePlayerOSXTests: XCTestCase {

    override func setUp() {
        super.setUp()
        MPCGamePlayerOSX.deleteUniqueIDList()
    }

    override func tearDown() {
        MPCGamePlayerOSX.deleteUniqueIDList()
        super.tearDown()
    }

    func testReuseUniqueIdOnInit() {
        var foo : MPCGamePlayerOSX?
        var newFoo: NSUUID!
        var fooId: String

        var bar : MPCGamePlayerOSX?
        var barId: String

        XCTAssertTrue(MPCGamePlayerOSX.uniqueIDList().isEmpty);

        foo = MPCGamePlayerOSX()
        fooId = foo!.uniqueID.UUIDString
        XCTAssertEqual(MPCGamePlayerOSX.uniqueIDList().count, 1, "id list should contain 1 ids")
        XCTAssertEqual(MPCGamePlayerOSX.uniqueIDList()[foo!.uniqueID]!, 1, "id list should contain 1 ids")

        bar = MPCGamePlayerOSX()
        barId = bar!.uniqueID.UUIDString
        XCTAssertEqual(MPCGamePlayerOSX.uniqueIDList().count, 2, "id list should contain 2 ids")

        foo = nil

        newFoo = MPCGamePlayerOSX().uniqueID
        XCTAssertEqual(fooId, newFoo.UUIDString, "foo should reuse an id")
        XCTAssertNotEqual(fooId, barId, "bar should not use foos id")
    }

}
