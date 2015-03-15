//
//  Apple.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class AppleBackup: NSObject {
    
    // MARK: Properties
    var xLowerBound: Float = 0
    var yLowerBound: Float = 0
    var xUpperBound: Float = 0
    var yUpperBound: Float = 0
    
    var locationX: Float = 0
    var locationY: Float = 0
    
    private var updateLocationTimer: NSTimer!
    private var defaultUpdateLocationTimerInterval: NSTimeInterval = 20.0
    private var updateLocationTimerInterval: NSTimeInterval = 20.0 {
        didSet {
            if updateLocationTimerInterval <= 5.0 {
                updateLocationTimerInterval = oldValue
            }
        }
    }
    private var updateLocationTimerDelta = 0.02
    
//    var delegate: AppleDelegate?
    
    
    // MARK: Initializers
    
    init(xLowerBound: Float, xUpperBound: Float, yLowerBound: Float, yUpperBound: Float){
        
        super.init()
        
        // Bounds limits are used to determine the range of potential locations of an apple
        // Since the apple location is based on its center, the limits need to be adjusted by 0.5
        // Each potential location is measured by increments of 1.0
        self.xLowerBound = xLowerBound + 0.5
        self.xUpperBound = xUpperBound - 0.5
        self.yLowerBound = yLowerBound + 0.5
        self.yUpperBound = yUpperBound - 0.5
        
        updateLocation()
        
        scheduleUpdateLocationTimer()
    }
    
    deinit{
        updateLocationTimer.invalidate()
    }
    
    private func scheduleUpdateLocationTimer() {
        updateLocationTimer = NSTimer(timeInterval: updateLocationTimerInterval,
            target: self,
            selector: "updateLocation",
            userInfo: nil,
            repeats: true)
        
        NSRunLoop.currentRunLoop().addTimer(updateLocationTimer, forMode: NSDefaultRunLoopMode)
        updateLocationTimer.fire()
    }
    
    
    // MARK: Actions
    
    func updateLocation() {
        var locationX, locationY : Float
        
        let rangeX = UInt32(xUpperBound) - UInt32(xLowerBound)
        self.locationX = xLowerBound + Float(arc4random_uniform(rangeX))
        
        let rangeY = UInt32(yUpperBound) - UInt32(xLowerBound)
        self.locationY = yLowerBound + Float(arc4random_uniform(rangeY))
        
//        if let _delegate = delegate {
//            _delegate.didUpdateLocation(self)
//        }
    }
    
    func move() {
        
        updateLocation()
        
        updateLocationTimer.invalidate()
        updateLocationTimerInterval -= updateLocationTimerDelta
        scheduleUpdateLocationTimer()
    }
    
    func destroy() {
        updateLocationTimer.invalidate()
        updateLocationTimerInterval = defaultUpdateLocationTimerInterval
    }
}