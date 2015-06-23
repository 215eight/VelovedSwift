//
//  InputViewDelegate.swift
//  GameSwift
//
//  Created by eandrade21 on 6/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

public protocol InputViewDelegate {
    func processKeyInput(key: String, transform: StageViewTransform)
    func processSwipe(direction: Direction)
    func processPauseOrResume()
}