//
//  KeyBindings.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

struct KeyboardControlBindings {
    
    struct KeyboardControlGenerator: GeneratorType {
        
        var controls: [[String]]
        
        mutating func next() -> [String]? {
            
            if controls.isEmpty { return nil }
            
            let next = controls.first
            controls.removeAtIndex(0)
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
    
    var controllers: KeyboardControlGenerator
    
    init() {
        bindings = [config_one, config_two, config_three]
        controllers = KeyboardControlGenerator(controls: bindings.map( { Array($0.keys) } ))
    }
    
    func getDirectionForKey(key: String) -> Direction? {
        
        for config in bindings {
            if let direction = config[key] {
                return direction
            }
        }
        
        return nil
    }
    
}