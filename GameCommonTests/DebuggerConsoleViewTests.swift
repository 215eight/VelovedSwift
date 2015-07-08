//
//  DebuggerConsoleViewTests.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/10/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class DebuggerConsoleViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProperties() {
        let view = DebuggerConsoleView(cols: 10, rows: 1)

        XCTAssertEqual(view.viewElements.count, 1, "View should only have one row")
        XCTAssertEqual(view.viewElements[0].count, 10, "The only row should have 10 columns")
        XCTAssertEqual(view.description, "          ", "Its description should be 10 white spaces")
    }

    func testDescription() {
        let view = DebuggerConsoleView(cols: 5, rows: 5)
        let viewDescription = "     \n" + "     \n" + "     \n" + "     \n" + "     "

        XCTAssertEqual(view.description, viewDescription, "It should have 5 row with 5 columns each. All whitespaces ")

    }

    func testUpdateCoordinate() {
        var view = DebuggerConsoleView(cols: 2, rows: 2)
        view.updateCoordinate(0, 0, "#")

        XCTAssertEqual(view.description, "# \n  ", "First character of first row should be #")
    }

    func testUpdateElementRefresh() {

        var target = Target(locations: [StageLocation.zeroLocation()], points: 10)
        var view = DebuggerConsoleView(cols: 3, rows: 1)
        view.updateElment(target)

        XCTAssertEqual(view.description, "\(target.locationDesc)  ", "Target is drawn at the beginning of the line")
        XCTAssertEqual(view.elements.count, 1, "It contains the target")

        target.locations = [StageLocation(x: 1, y: 0)]
        view.updateElment(target)

        XCTAssertEqual(view.description, " \(target.locationDesc) ", "Target was erased form the first position and drawn in the second position")
        XCTAssertEqual(view.elements.count, 1, "Still contains the target")

        target.locations = [StageLocation(x: 2, y: 0)]
        view.updateElment(target)

        XCTAssertEqual(view.description, "  \(target.locationDesc)", "Target was erased form the second position and drawn in the third position")
        XCTAssertEqual(view.elements.count, 1, "Still contains the target")
    }

    func testUpdateElement() {
        let target = TargetMock()
        var view = DebuggerConsoleView(cols: 2, rows: 2)
        view.updateElment(target)

        XCTAssertEqual(view.description, "\(target.locationDesc) \n  ", "First character of first row should be a red Target")
    }
}
