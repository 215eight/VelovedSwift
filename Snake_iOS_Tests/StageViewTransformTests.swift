////
////  StageViewTransformTests.swift
////  SnakeSwift
////
////  Created by eandrade21 on 3/17/15.
////  Copyright (c) 2015 PartyLand. All rights reserved.
////
//
//import UIKit
//import XCTest
//
//class StageViewTransformTests: XCTestCase {
//
//    var frame: CGRect!
//    var stageSize: StageSize!
//    var svt: StageViewTransform!
//    
//    override func setUp() {
//        super.setUp()
//        
//        frame = CGRect(x: 0, y: 0, width: 375, height: 667)
//        stageSize = StageSize(width: 32, height: 56)
//        svt = StageViewTransform(frame: frame, stageSize: stageSize)
//         
//    }
//    
//    override func tearDown() {
//        svt = nil
//        stageSize = nil
//        frame = nil
//        super.tearDown()
//    }
//
//    func testInit_iPhone6() {
//        
//       
//        XCTAssertEqual(svt.scaleFactor, CGFloat(375.0/32.0), "Scale factor")
//        XCTAssertEqual(svt.offset.x, CGFloat(0), "No padding on x-axis")
//        XCTAssertEqual(svt.offset.y, CGFloat(5.375), "Padding on y-axis")
//        
//    }
//    
//    func testGetFrameLandscape() {
//        
//        let frame = CGRect(x: 0, y:0, width: 375, height: 667)
//        let stageSize = StageSize(width: 32, height: 56)
//        let svt = StageViewTransform(frame: frame, stageSize: stageSize)
//        
//        let location = StageLocation(x: 0, y: 0)
//        let portraitFrame = CGRect(x: 0, y: 0, width: svt.scaleFactor, height: svt.scaleFactor)
//        let landscapeLeftFrame = CGRect(x:0, y:svt.stageFrame.width - svt.scaleFactor, width: svt.scaleFactor, height: svt.scaleFactor)
//        let landscapeRightFrame = CGRect(x: svt.stageFrame.height - svt.scaleFactor, y:0, width: svt.scaleFactor, height: svt.scaleFactor)
//    
//        XCTAssertEqual(svt.getFrame(location, orientation: UIDeviceOrientation.Portrait), portraitFrame, "Frames should match")
//        XCTAssertEqual(svt.getFrame(location, orientation: UIDeviceOrientation.LandscapeLeft), landscapeLeftFrame, "Frames should match")
//        XCTAssertEqual(svt.getFrame(location, orientation: UIDeviceOrientation.LandscapeRight), landscapeRightFrame, "Frames should match")
//        
//    }
//    
//    
//    func testReverseDirection() {
//        
//        var reversedDirection = svt.reverseDirection(UISwipeGestureRecognizerDirection.Down)
//        XCTAssertTrue(reversedDirection == .Up, "Down reversed to Up")
//        
//        reversedDirection = svt.reverseDirection(UISwipeGestureRecognizerDirection.Up)
//        XCTAssertTrue(reversedDirection == .Down, "Up reversed to Down")
//        
//        reversedDirection = svt.reverseDirection(UISwipeGestureRecognizerDirection.Right)
//        XCTAssertTrue(reversedDirection == .Left, "Right reversed to Left")
//        
//        reversedDirection = svt.reverseDirection(UISwipeGestureRecognizerDirection.Left)
//        XCTAssertTrue(reversedDirection == .Right, "Left reversed to Right")
//    }
//    
//    func testInvertDirection() {
//        
//        var invertedDirection = svt.inverseDirection(UISwipeGestureRecognizerDirection.Right)
//        XCTAssertTrue(invertedDirection == .Up, "Inverse of Right is Up")
//        
//        invertedDirection = svt.inverseDirection(UISwipeGestureRecognizerDirection.Left)
//        XCTAssertTrue(invertedDirection == .Down, "Inverse of Left is Down")
//        
//        invertedDirection = svt.inverseDirection(UISwipeGestureRecognizerDirection.Up)
//        XCTAssertTrue(invertedDirection == .Right, "Inverse of Up is Right")
//        
//        invertedDirection = svt.inverseDirection(UISwipeGestureRecognizerDirection.Down)
//        XCTAssertTrue(invertedDirection == .Left, "Inverse of Down is Left")
//    }
//    
//    func testGetDirectionPortrait() {
//        
//        let orientation = UIDeviceOrientation.Portrait
//        
//        var direction = svt.getDirection(.Right, orientation: orientation)
//        XCTAssertTrue(direction == .Right, "Right")
//        
//        direction = svt.getDirection(.Left, orientation: orientation)
//        XCTAssertTrue(direction == .Left, "Left")
//        
//        direction = svt.getDirection(.Up, orientation: orientation)
//        XCTAssertTrue(direction == .Up, "Up")
//        
//        direction = svt.getDirection(.Down, orientation: orientation)
//        XCTAssertTrue(direction == .Down, "Down")
//        
//    }
//}
