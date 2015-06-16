//
//  MenuOptions.swift
//  GameSwift
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

public struct MenuOptions {

    public init(){
    }

    var menu = [String]()

    public mutating func getMenu() -> [String] {

        if menu.isEmpty {
            menu.append("Play")
            menu.append("Host Race")
            menu.append("Join Race")
            menu.append("Credits")
        }
        return menu
    }
}