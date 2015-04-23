//
//  MenuOptions.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

struct MenuOptions {

    var menu = [String]()

    mutating func getMenu() -> [String] {

        if menu.isEmpty {
            menu.append("Single Player Game")
            menu.append("Host Multiplayer Game")
            menu.append("Join Multiplayer Game")
            menu.append("Settings")
        }
        return menu
    }
}