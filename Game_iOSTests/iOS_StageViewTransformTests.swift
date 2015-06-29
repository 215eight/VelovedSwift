//
//  iOS_StageViewTransformTests.swift
//  VelovedGame
//
//  Created by eandrad21 on 4/8/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import XCTest
import VelovedCommon

class iOS_StageViewTransformTests: XCTestCase {
    
    var stageSize = DefaultStageSize

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitIPhone6() {
        
        let iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(deviceSVT: iOS_svt)
        mock_svt.windowSize = CGSize(width: 375, height: 667)
        mock_svt.currentOrientation = .Portrait

        XCTAssertEqual(mock_svt.scaleFactor, CGFloat(375.0/32.0), "Scale factor")

        let stageFrame = mock_svt.getStageFrame()
        XCTAssertEqual(stageFrame.origin.x, CGFloat(0), "No padding on the x-axis")
        XCTAssertEqual(stageFrame.origin.y, CGFloat(5.375), "Padding on the y-axis")
        XCTAssertEqual(stageFrame.size.width, CGFloat(375), "Stage width equal to 375 points")
        XCTAssertEqual(stageFrame.size.height, CGFloat(667-(5.375*2)), "Stage height equal to 656.25 points")
    }

    func testInitIPhone5() {
        let iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(deviceSVT: iOS_svt)
        mock_svt.windowSize = CGSize(width: 320, height: 568)
        mock_svt.currentOrientation = .Portrait

        XCTAssertEqual(mock_svt.scaleFactor, CGFloat(10.0), "Scale factor")

        var stageFrame = mock_svt.getStageFrame()
        XCTAssertEqual(stageFrame.origin.x, CGFloat(0), "No padding on the x-axis")
        XCTAssertEqual(stageFrame.origin.y, CGFloat(4), "Padding on the y-axis")
        XCTAssertEqual(stageFrame.size.width, CGFloat(320), "Stage width equal to 320 points")
        XCTAssertEqual(stageFrame.size.height, CGFloat(560), "Stage height equal to 560 points")

        mock_svt.currentOrientation = .LandscapeRight
        stageFrame = mock_svt.getStageFrame()
        XCTAssertEqual(stageFrame.origin.x, CGFloat(4), "Padding on the x-axis")
        XCTAssertEqual(stageFrame.origin.y, CGFloat(0), "No padding on the x-axis")
        XCTAssertEqual(stageFrame.size.width, CGFloat(560), "Stage width equal to 560 points")
        XCTAssertEqual(stageFrame.size.height, CGFloat(320), "Stege height equal to 320 points")
    }
    
    func testGetFramePortraitOrientation() {
        
        var iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(deviceSVT: iOS_svt)
        mock_svt.windowSize = CGSize(width: 375, height: 667)
        mock_svt.currentOrientation = .Portrait

        var frame = CGRect(x: 0, y: 0, width: mock_svt.scaleFactor, height: mock_svt.scaleFactor)
        var getFrame = mock_svt.getFrame(StageLocation.zeroLocation())
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

        frame = CGRect(x: CGFloat(DefaultStageSize.width - 1) * mock_svt.scaleFactor,
            y: 0,
            width: mock_svt.scaleFactor,
            height: mock_svt.scaleFactor)
        getFrame = mock_svt.getFrame(StageLocation(x: DefaultStageSize.width - 1, y: 0))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

        frame = CGRect(x: 0,
            y: CGFloat(DefaultStageSize.height - 1) * mock_svt.scaleFactor,
            width: mock_svt.scaleFactor,
            height: mock_svt.scaleFactor)
        getFrame = mock_svt.getFrame(StageLocation(x: 0, y: DefaultStageSize.height - 1))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

        frame = CGRect(x: CGFloat(DefaultStageSize.width - 1) * mock_svt.scaleFactor,
            y: CGFloat(DefaultStageSize.height - 1) * mock_svt.scaleFactor,
            width: mock_svt.scaleFactor,
            height: mock_svt.scaleFactor)
        getFrame = mock_svt.getFrame(StageLocation(x: DefaultStageSize.width - 1, y: DefaultStageSize.height - 1))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

    }

    func testGetFrameLandscapeLeftOrientation() {
        var iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(deviceSVT: iOS_svt)
        mock_svt.windowSize = CGSize(width: 375, height: 667)
        mock_svt.currentOrientation = .LandscapeLeft

        var frame = CGRect(x: 0, y: 0, width: mock_svt.scaleFactor, height: mock_svt.scaleFactor)
        var getFrame = mock_svt.getFrame(StageLocation(x: DefaultStageSize.width - 1, y: 0))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

        frame = CGRect(x: CGFloat(DefaultStageSize.height - 1) * mock_svt.scaleFactor,
            y: 0,
            width: mock_svt.scaleFactor,
            height: mock_svt.scaleFactor)
        getFrame = mock_svt.getFrame(StageLocation(x: DefaultStageSize.width - 1, y: DefaultStageSize.height - 1))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

        frame = CGRect(x: 0,
            y: CGFloat(DefaultStageSize.width - 1) * mock_svt.scaleFactor,
            width: mock_svt.scaleFactor,
            height: mock_svt.scaleFactor)
        getFrame = mock_svt.getFrame(StageLocation(x: 0, y: 0))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

        frame = CGRect(x: CGFloat(DefaultStageSize.height - 1) * mock_svt.scaleFactor,
            y: CGFloat(DefaultStageSize.width - 1) * mock_svt.scaleFactor,
            width: mock_svt.scaleFactor,
            height: mock_svt.scaleFactor)
        getFrame = mock_svt.getFrame(StageLocation(x: 0, y: DefaultStageSize.height - 1))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

   }

    func testGetFrameLandscapeRigthOrientation() {
        var iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(deviceSVT: iOS_svt)
        mock_svt.windowSize = CGSize(width: 375, height: 667)
        mock_svt.currentOrientation = .LandscapeRight

        var frame = CGRect(x: 0, y: 0, width: mock_svt.scaleFactor, height: mock_svt.scaleFactor)
        var getFrame = mock_svt.getFrame(StageLocation(x: 0, y: DefaultStageSize.height - 1))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

        frame = CGRect(x: CGFloat(DefaultStageSize.height - 1) * mock_svt.scaleFactor,
            y: 0,
            width: mock_svt.scaleFactor,
            height: mock_svt.scaleFactor)
        getFrame = mock_svt.getFrame(StageLocation(x: 0, y: 0))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

        frame = CGRect(x: 0,
            y: CGFloat(DefaultStageSize.width - 1) * mock_svt.scaleFactor,
            width: mock_svt.scaleFactor,
            height: mock_svt.scaleFactor)
        getFrame = mock_svt.getFrame(StageLocation(x: DefaultStageSize.width - 1, y: DefaultStageSize.height - 1))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")

        frame = CGRect(x: CGFloat(DefaultStageSize.height - 1) * mock_svt.scaleFactor,
            y: CGFloat(DefaultStageSize.width - 1) * mock_svt.scaleFactor,
            width: mock_svt.scaleFactor,
            height: mock_svt.scaleFactor)
        getFrame = mock_svt.getFrame(StageLocation(x: DefaultStageSize.width - 1, y: 0))
        XCTAssertEqual(getFrame, frame, "Current: \(getFrame) Expected: \(frame)")
    }

    func testGetDirectionPortrait() {

        var iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(deviceSVT: iOS_svt)
        mock_svt.windowSize = CGSize(width: 375, height: 667)
        mock_svt.currentOrientation = StageOrientation.Portrait

        var direction = mock_svt.getDirection(.Right)
        XCTAssertTrue(direction == .Right, "Right")
        
        direction = mock_svt.getDirection(.Left)
        XCTAssertTrue(direction == .Left, "Left")
        
        direction = mock_svt.getDirection(.Up)
        XCTAssertTrue(direction == .Up, "Up")
        
        direction = mock_svt.getDirection(.Down)
        XCTAssertTrue(direction == .Down, "Down")
    }

    func testGetDirectionLanscapeLeft() {

        var iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(deviceSVT: iOS_svt)
        mock_svt.currentOrientation = StageOrientation.LandscapeLeft

        var direction = mock_svt.getDirection(.Up)
        XCTAssertTrue(direction == .Right, "Incorrect Direction - Current: \(direction) Expected: Right")

        direction = mock_svt.getDirection(.Left)
        XCTAssertTrue(direction == .Up, "Incorrect Direction - Current: \(direction) Expected: Up")

        direction = mock_svt.getDirection(.Down)
        XCTAssertTrue(direction == .Left, "Incorrect Direction - Current: \(direction) Expected: Left")

        direction = mock_svt.getDirection(.Right)
        XCTAssertTrue(direction == .Down, "Incorrect Direction - Current: \(direction) Expected: Down")
    }

    func testGetDirectionLanscapeRight() {

        var iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(deviceSVT: iOS_svt)
        mock_svt.currentOrientation = StageOrientation.LandscapeRight

        var direction = mock_svt.getDirection(.Up)
        XCTAssertTrue(direction == .Left, "Incorrect Direction - Current: \(direction) Expected: Left")

        direction = mock_svt.getDirection(.Left)
        XCTAssertTrue(direction == .Down, "Incorrect Direction - Current: \(direction) Expected: Down")

        direction = mock_svt.getDirection(.Down)
        XCTAssertTrue(direction == .Right, "Incorrect Direction - Current: \(direction) Expected: Right")

        direction = mock_svt.getDirection(.Right)
        XCTAssertTrue(direction == .Up, "Incorrect Direction - Current: \(direction) Expected: Up")
    }

}
