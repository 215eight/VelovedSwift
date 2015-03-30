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
        if previous == current {
            return true
        }
        previous = current
        current = sortedGenerator.next()
    }
    return false
}

func intersects<T where T: Equatable>(source: [T], target:[Array<T>]) -> Bool {
    
    let targetBool = map(target) { (targetLocations: Array<T>) -> [Bool] in
        return map(source) { (sourceLocation: T) -> Bool in
            return contains(targetLocations, sourceLocation)
        }
    }
    
    var intersects = map(targetBool) { (bools: Array<Bool>) -> Bool in
        return bools.reduce(true) { (lhs: Bool, rhs: Bool) in lhs && !rhs }
        }.reduce(true) {$0 && $1}
    
    return !intersects
}

func intersects<T where T: Equatable>(element: T, target:[Array<T>]) -> Bool {
    
    return intersects([element], target)
}


func intersects(source: [StageElement], target: [StageElement]) -> [StageElement] {
    
    var container = [StageElement]()
    
    let targetLocations = target.map(){ $0.locations }
    
    for sourceElement in source {
        if intersects(sourceElement.locations, targetLocations) {
            container.append(sourceElement)
        }
    }
    
    return container
}

func intersects(source: [StageElement], target: StageElement) -> [StageElement] {
    return intersects(source, [target])
}