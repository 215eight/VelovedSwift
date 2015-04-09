//
//  SnakeController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

class SnakeController {
    
    // MARK: Properties
    var bindings: KeyboardControlBindings
    var keySnakeMapping = [String : Snake]()
    
    // MARK: Initializers
    init(bindings: KeyboardControlBindings) {
        self.bindings = bindings
    }
    
    func registerSnake(snake: Snake) -> Bool {
        if let controller = bindings.controllers.next() {
            
            for key in controller {
                keySnakeMapping[key] = snake
            }
            return true
        }
        return false
    }
    
    func processKeyInput(key: String) {
        if let snake = keySnakeMapping[key] {
            if let direction = bindings.getDirectionForKey(key) {
                snake.direction = direction
            }
        }
    }

    
}