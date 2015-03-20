//
//  File.swift
//  SnakeSwift
//
//  Created by PartyMan on 3/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

protocol StageLocatable: Equatable {
    var locations: [StageLocation] { get }
}