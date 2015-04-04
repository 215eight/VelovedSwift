//
//  StageXViewTransform.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/30/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit

class StageXViewTransform {

    // Properties
    let stageSize: StageSize
    var scaleFactor: Int!
    var stageFrame: CGRect!
    
    // Initializer
    init(stageSize: StageSize){
        self.stageSize = stageSize
        configureTerminal()
    }
    
    func configureTerminal() {
        
        if let screen = NSScreen.mainScreen() {
            
            calculateScaleFactor()
            calculateStageFrame()
            resizeTerminal()
            centerTerminal(screen.frame)
            
        } else {
            assertionFailure("Screen information not available. Unable to start the game")
        }
    }
    
    func calculateScaleFactor() {
        
        // TODO: Calculate how many times the stage fits in the screen to set the scale factor
        scaleFactor = 2
    }
    
    func calculateStageFrame() {
        
        let size = CGSize(width: stageSize.height * scaleFactor, height: stageSize.width * scaleFactor)
        stageFrame = CGRect(origin: CGPointZero, size: size)
    }
    
    func centerTerminal(screenFrame: CGRect) {
        
        
        // TODO: Get the size of the terminal programatically
//        let getTerminalSizeInPixels = NSTask()
//        getTerminalSizeInPixels.launchPath = "/usr/bin/printf"
//        getTerminalSizeInPixels.arguments = ["\\33[14t"]
//        let pipe = NSPipe()
//        getTerminalSizeInPixels.standardOutput  = pipe
//        getTerminalSizeInPixels.launch()
//        
//        
//        var data = pipe.fileHandleForReading.readDataToEndOfFile()
//        println(data)
//        var output = NSString(data: data, encoding: NSASCIIStringEncoding)
//        println("Output: \(output!)")
        
        
        let wTerm = 794
        let hTerm = 963
        
        let wTermHalf = CGFloat(wTerm / 2)
        let hTermHalf = CGFloat(hTerm / 2)
        
        let wScreenHalf = screenFrame.size.width / 2
        let hScreenHalf = screenFrame.size.height / 2
        
        let xOrigin = Int(screenFrame.origin.x + wScreenHalf - wTermHalf)
        let yOrigin = Int(screenFrame.origin.y + hScreenHalf - hTermHalf)
        println("Frame Origin X:\(screenFrame.origin.x) Y:\(screenFrame.origin.y)")
        println("Half Screen: W: \(wScreenHalf) H:\(hScreenHalf)")
        println("Origin X:\(xOrigin) Y:\(yOrigin)")
        
        let moveTerminal = NSTask()
        moveTerminal.launchPath = "/usr/bin/printf"
        moveTerminal.arguments =  ["\\33[3;\(xOrigin);\(yOrigin)t"]
        moveTerminal.launch()
        
    }
    
    func resizeTerminal() {
        
        let width = Int(stageFrame.size.width)
        let height = Int(stageFrame.size.height)
        
        let task = NSTask()
        task.launchPath = "/usr/bin/printf"
        task.arguments =  ["\\33[8;\(height);\(width)t"]
        task.launch()
    }
    
    // Instance methods
    
    func getFrame(location: StageLocation) -> CGRect {
        
        let x = location.y * scaleFactor
        let y = ((stageSize.width - 1) * scaleFactor) - (location.x * scaleFactor)
        
        return CGRect(x: x, y: y, width: scaleFactor, height: scaleFactor)
        
    }
    
    func getDirection(direction: Direction) -> Direction {
        
        // Terminal orientation is simalar to .LandscapeLeft
        
        var newDirection: Direction
        
        switch direction{
        case .Up:
            newDirection = .Right
        case .Down:
            newDirection = .Left
        case .Right:
            newDirection = .Down
        case .Left:
            newDirection = .Up
        }
        
        return newDirection
    }
}