//
//  MenuOptions.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

public struct MenuOptions {

    private var _menu = [String]()

    public var menu: [String] {
        return _menu
    }

    public var numberOfMenuOptions: Int {
        return _menu.count
    }

    public init(){
        _menu.append("Logo")
        _menu.append("Play")
        _menu.append("Host Race")
        _menu.append("Join Race")
        _menu.append("Credits")
    }

}