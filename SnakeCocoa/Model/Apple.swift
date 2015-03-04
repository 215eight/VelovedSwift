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

    
    init(xLowerBound: Float, xUpperBound: Float, yLowerBound: Float, yUpperBound: Float, randomize: Bool){
        
        self.xLowerBound = xLowerBound
        self.xUpperBound = xUpperBound
        self.yLowerBound = yLowerBound
        self.yUpperBound = yUpperBound
        
        // Calculate random location
        
        
        // Set location
        locationX = xLowerBound + 0
        locationY = yLowerBound + 10
    }
    
    func updateLocation() {
        
        // Calculate random location
        
        // Set location
        
        locationX = xLowerBound + 0
        locationY = yLowerBound + 20
    }
    
    
    
    
}
