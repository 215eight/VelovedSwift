//
//  PlayerController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

class PlayerController {
    
    // MARK: Properties
    private var bindings: KeyboardControlBindings
    private var keyPlayerMapping = [String : Player]()
    var isProcessingKeyInput = false
    
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
        if isProcessingKeyInput {
            if let player = keyPlayerMapping[key] {
                player.direction = direction
            }
        }
    }

    func getDirectionForKey(key: String) -> Direction? {
        if isProcessingKeyInput {
            return bindings.getDirectionForKey(key)
        }
        return nil
    }
}