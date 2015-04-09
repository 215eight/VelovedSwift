//
//  StageConfigurator.swift
//  SnakeSwift
//
//  Created by eandrade21 3/12/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

protocol StageConfigurator {
    
    var size: StageSize { get }
    var elements: [String: [StageElement]] { get }
    
    init(size: StageSize)
    
}
