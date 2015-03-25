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

func duplicates<C : SequenceType where C.Generator.Element : Comparable>(source: C) -> Bool {
    
    var generator = source.generate()
    var isSourceEmpty = generator.next()
    
    if isSourceEmpty == nil { return false }
    
    let sortedSource = sorted(source, { (lhs: C.Generator.Element, rhs: C.Generator.Element) -> Bool in return lhs < rhs })
    
    var sortedGenerator = sortedSource.generate()
    var previous = sortedGenerator.next()
    var current = sortedGenerator.next()
    
    while (current != nil) {
        //println("Previous: \(previous!) - Current: \(current!)")
        if previous == current {
            return true
        }
        previous = current
        current = sortedGenerator.next()
    }
    return false
}