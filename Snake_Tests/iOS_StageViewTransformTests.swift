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
    var svt: StageViewTransform!

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
        var mock_svt = iOS_StageViewTransformMock(svt: iOS_svt)
        mock_svt.testWindowSize = CGSize(width: 375, height: 667)
        mock_svt.testOrientation = .Portrait
        svt = StageViewTransform(deviceTransform: mock_svt)
        
        XCTAssertEqual(svt.scaleFactor, CGFloat(375.0/32.0), "Scale factor")
        XCTAssertEqual(svt.stageFrame.origin.x, CGFloat(0), "No padding on the x-axis")
        XCTAssertEqual(svt.stageFrame.origin.y, CGFloat(5.375), "Padding on the y-axis")
        
        svt = nil
    }
    
    func testGetFrameInCurrenOrientation() {
        
        var iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(svt: iOS_svt)
        mock_svt.testWindowSize = CGSize(width: 375, height: 667)
        svt = StageViewTransform(deviceTransform: mock_svt)
        
        let portraitFrame = CGRect(x: 0, y: 0, width: svt.scaleFactor, height: svt.scaleFactor)
        let landscapeLeftFrame = CGRect(x:0, y:svt.stageFrame.width - svt.scaleFactor, width: svt.scaleFactor, height: svt.scaleFactor)
        let landscapeRightFrame = CGRect(x: svt.stageFrame.height - svt.scaleFactor, y:0, width: svt.scaleFactor, height: svt.scaleFactor)
        
        mock_svt.testOrientation = .Portrait
        XCTAssertEqual(svt.getFrame(StageLocation.zeroLocation()), portraitFrame, "Portrait Frame")
        
        mock_svt.testOrientation = .LandscapeLeft
        XCTAssertEqual(svt.getFrame(StageLocation.zeroLocation()), landscapeLeftFrame, "LandscapeLeft Frame")
        
        mock_svt.testOrientation = .LandscapeRight
        XCTAssertEqual(svt.getFrame(StageLocation.zeroLocation()), landscapeRightFrame, "LandscapeRight Frame")
        
        svt = nil
    }
    
    func testGetDirectionPortrait() {
        
        
        var iOS_svt = iOS_StageViewTransform()
        var mock_svt = iOS_StageViewTransformMock(svt: iOS_svt)
        mock_svt.testWindowSize = CGSize(width: 375, height: 667)
        mock_svt.testOrientation = StageOrientation.Portrait
        
        
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
