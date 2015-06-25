//
//  iOS_Utils.swift
//  GameSwift
//
//  Created by on endrade 21 6/21/15.
//  Copyright (c[po 2015 PartyLand. All rights reserved.
//

import UIKit

let InfoAlertTitleFontSize: CGFloat = 22
let InfoAlertMessageFontSize: CGFloat = 16

let InfoAlertCrashedTitle = "😵 Game Over 😵"
let InfoAlertCrashedMessage = "Waiting until race ends"
let InfoAlertUpdateCrashedMessage = "Race is over"

let InfoAlertWonTitle = "🏁🏆 Race Winner! 🏆🏁"
let InfoAlertWonMessage = "Congratulations"

let InfoAlertMainMenuActionTitle = "Main Menu"

let InfoAlertRaceActionTitle = "Race Again"

let ErrorAlertTitle = "Error"
let ErrorAlertMessage = "Player left game. Oops!"
let ErrorAlertDismissActionTitle = "Dismiss"


func degree2radian(degree: CGFloat) -> CGFloat {
    return CGFloat(M_PI) * degree / 180
}