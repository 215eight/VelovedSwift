//
//  PlayerController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

class PlayerController {
    
    // MARK: Properties
    var bindings: KeyboardControlBindings
    var keyPlayerMapping = [String : Player]()
    
    // MARK: Initializers
    init(bindings: KeyboardControlBindings) {
        self.bindings = bindings
    }
    
    func registerPlayer(player: Player) -> Bool {
        if let controller = bindings.controllers.next() {
            
            for key in controller {
                keyPlayerMapping[key] = player
            }
            return true
        }
        return false
    }
    
    func processKeyInput(key: String, direction: Direction) {
        if let player = keyPlayerMapping[key] {
            player.direction = direction
        }
    }

    
}