//
//  KeyBindings.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

struct KeyboardControlBindings: GeneratorType {
    
    struct KeyBindingsGenerator: GeneratorType {
        
        var bindings: [[String : Direction]]
        
        mutating func next() -> [String : Direction]? {
            
            if bindings.isEmpty { return nil }
            
            let next = bindings.first
            bindings.removeAtIndex(0)
            return next
        }
    }
    
    private let config_one = [ "a" : Direction.Left,
        "d" : Direction.Right,
        "w" : Direction.Up,
        "s" : Direction.Down]
    
    private let config_two = [ "g" : Direction.Left,
        "j" : Direction.Right,
        "y" : Direction.Up,
        "h" : Direction.Down]
    
    private let config_three = [ "l" : Direction.Left,
        "'" : Direction.Right,
        "p" : Direction.Up,
        ";" : Direction.Down]
    
    private var bindings: [[String : Direction]]
    private var generator: KeyBindingsGenerator
    
    init() {
        bindings = [config_one, config_two, config_three]
        generator = KeyBindingsGenerator(bindings: bindings)
    }
    
    mutating func next() -> [String : Direction]? {
        return generator.next()
    }
}