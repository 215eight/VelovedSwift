//
//  StageViewTransformTests.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import XCTest

class StageViewTransformTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit_iPhone6() {
        
        let frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        let stageSize = StageSize(width: 32, height: 56)
        let svt = StageViewTransform(frame: frame, stageSize: stageSize)
        
        XCTAssertEqual(svt.scaleFactor, CGFloat(375.0/32.0), "Scale factor")
        XCTAssertEqual(svt.offset.x, CGFloat(0), "No padding on x-axis")
        XCTAssertEqual(svt.offset.y, CGFloat(5.375), "Padding on y-axis")
        
    }
    
    func testGetFrameLandscape() {
        
        let frame = CGRect(x: 0, y:0, width: 375, height: 667)
        let stageSize = StageSize(width: 32, height: 56)
        let svt = StageViewTransform(frame: frame, stageSize: stageSize)
        
        let location = StageLocation(x: 0, y: 0)
        let portraitFrame = CGRect(x: 0, y: 0, width: svt.scaleFactor, height: svt.scaleFactor)
        let landscapeLeftFrame = CGRect(x:0, y:svt.stageFrame.width - svt.scaleFactor, width: svt.scaleFactor, height: svt.scaleFactor)
        let landscapeRightFrame = CGRect(x: svt.stageFrame.height - svt.scaleFactor, y:0, width: svt.scaleFactor, height: svt.scaleFactor)
    
        XCTAssertEqual(svt.getFrame(location, orientation: UIDeviceOrientation.Portrait), portraitFrame, "Frames should match")
        XCTAssertEqual(svt.getFrame(location, orientation: UIDeviceOrientation.LandscapeLeft), landscapeLeftFrame, "Frames should match")
        XCTAssertEqual(svt.getFrame(location, orientation: UIDeviceOrientation.LandscapeRight), landscapeRightFrame, "Frames should match")
        
    }
}
