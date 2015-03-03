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
    var xAxisUpperBound: Float = 0
    var yAxisUpperBound: Float = 0
    
    var locationX: Float = 0
    var locationY: Float = 0
    
    var size: Float = 5.0  //radius of the apple
    
    init(randomize: Bool, xUpperBound: CGFloat, yUpperBoud: CGFloat){
        
        // Calculate random location
        
        // Set location
        locationX = 100.0
        locationY = 250.0
    }
    
    
    
    
}
