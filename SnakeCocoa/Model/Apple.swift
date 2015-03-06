//
//  Apple.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class Apple: NSObject {
   
    // MARK: Properties
    var xLowerBound: Float = 0
    var yLowerBound: Float = 0
    var xUpperBound: Float = 0
    var yUpperBound: Float = 0
    
    var locationX: Float = 0
    var locationY: Float = 0

    var randomTimer: NSTimer!
    var defaultRandomTimerInterval: NSTimeInterval = 10.0
    var randomTimerInterval: NSTimeInterval = 10.0 {
        didSet {
            if randomTimerInterval <= 5.0 {
                randomTimerInterval = oldValue
            }
        }
    }
    var randomTimerDelta = 0.02
    
    init(xLowerBound: Float, xUpperBound: Float, yLowerBound: Float, yUpperBound: Float){
    
        super.init()
        
        // Bounds limits are used to determine the range of potential locations of an apple
        // Since the apple location is based on its center, the limits need to be adjusted by 0.5
        // Each potential location is measured by increments of 1.0
        self.xLowerBound = xLowerBound + 0.5
        self.xUpperBound = xUpperBound - 0.5
        self.yLowerBound = yLowerBound + 0.5
        self.yUpperBound = yUpperBound - 0.5
        
        // Calculate random location
        (self.locationX, self.locationY) = randomLocation()
    }
    
    func updateLocation() {
        
        // Calculate random location
        (self.locationX, self.locationY) = randomLocation()
    }
    
    func randomLocation() -> (locationX: Float, locationY: Float){
        
        var locationX, locationY : Float
        
        let rangeX = UInt32(xUpperBound) - UInt32(xLowerBound)
        locationX = xLowerBound + Float(arc4random_uniform(rangeX))
        
        let rangeY = UInt32(yUpperBound) - UInt32(xLowerBound)
        locationY = yLowerBound + Float(arc4random_uniform(rangeY))
        
        return (locationX, locationY)
    }
    
    func scheduleRandomTimerInterval() {
        randomTimer = NSTimer(timeInterval: defaultRandomTimerInterval,
            target: self,
            selector: "updateLocation",
            userInfo: nil,
            repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(randomTimer, forMode: NSDefaultRunLoopMode)
        randomTimer.fire()
    }
}
