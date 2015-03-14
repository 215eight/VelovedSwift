//
//  Array+Intersects.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

extension Array {
    
    func contains<T: Equatable where T == T>(element: T) -> Bool {
        if self.isEmpty { return false }
        
        for e in self {
           if (e as T)  == element { return true }
        }
        
        return false
    }
    
    func intersects<T: Equatable where T == T>(otherArray: [T]) -> [T] {
        if self.isEmpty || otherArray.isEmpty {
            return []
        }
        
        var collector: [T] = []
        for _element in self {
            let element = _element as T
            
            if otherArray.contains(element) {
                collector.append(element)
            }
        }
        
        return collector
    }
}