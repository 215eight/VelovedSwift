//
//  StageSize.swift
//  GameSwift
//
//  Created by eandrade21 on 3/12/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public struct StageSize : Printable {
    
    public let width: Int = 0
    public let height: Int = 0
    
    public var description: String {
        return "Stage Size x: \(width) y: \(height)"
    }
    
    init(width: Int, height: Int) {
        if width > 0 { self.width = width }
        if height > 0 { self.height = height }
    }
}