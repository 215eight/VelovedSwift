//
//  iOS_StageViewTransformTests.swift
//  SnakeSwift
//
//  Created by eandrad21 on 4/8/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import XCTest

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
    
    func testGetFrameInCurrenOrientation() {
        
        var iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(deviceSVT: iOS_svt)
        mock_svt.windowSize = CGSize(width: 375, height: 667)

        mock_svt.currentOrientation = .Portrait
        let portraitFrame = CGRect(x: 0, y: 0, width: mock_svt.scaleFactor, height: mock_svt.scaleFactor)
        XCTAssertEqual(mock_svt.getFrame(StageLocation.zeroLocation()), portraitFrame, "Portrait Frame")

        mock_svt.currentOrientation = .LandscapeLeft
        let landscapeLeftFrame = CGRect(x:0, y:mock_svt.getStageFrame().height - mock_svt.scaleFactor, width: mock_svt.scaleFactor, height: mock_svt.scaleFactor)
        XCTAssertEqual(mock_svt.getFrame(StageLocation.zeroLocation()), landscapeLeftFrame, "LandscapeLeft Frame")

        mock_svt.currentOrientation = .LandscapeRight
        let landscapeRightFrame = CGRect(x: mock_svt.getStageFrame().width - mock_svt.scaleFactor, y:0, width: mock_svt.scaleFactor, height: mock_svt.scaleFactor)
        XCTAssertEqual(mock_svt.getFrame(StageLocation.zeroLocation()), landscapeRightFrame, "LandscapeRight Frame")
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


}
