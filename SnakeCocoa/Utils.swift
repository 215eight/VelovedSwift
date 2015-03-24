//
//  Utils.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/24/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

func containsPredicate<S: SequenceType where S.Generator.Element: Equatable> (seq: S, element: S.Generator.Element) -> ((S) -> Bool) {
    
    func predicate(seq: S) -> Bool {
        return contains(seq, element)
    }
    
    return predicate
    
}
