//
//  StageSize.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/12/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

struct StageSize : Printable {
    
    let width: Float = 0
    let height: Float = 0
    
    var description: String {
        return "Stage Size x: \(width) y: \(height)"
    }
    
    init(width: Float, height: Float) {
        if width > 0 { self.width = width }
        if height > 0 { self.height = height }
    }
}