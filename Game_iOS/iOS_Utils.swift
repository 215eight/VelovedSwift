//
//  iOS_Utils.swift
//  VelovedGame
//
//  Created by on endrade 21 6/21/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

let InfoAlertTitleFontSize: CGFloat = 22
let InfoAlertMessageFontSize: CGFloat = 16

let InfoAlertCrashedTitle = "⚠️ Game Over ⚠️"
let InfoAlertCrashedMessage = "Waiting for other riders"
let InfoAlertUpdateCrashedMessage = "Race is over"

let InfoAlertWonTitle = "🏁 Race Winner! 🏁"
let InfoAlertWonMessage = "Congratulations"

let InfoAlertMainMenuActionTitle = "Main Menu"

let InfoAlertRaceActionTitle = "Race Again"

let ErrorAlertTitle = "Error"
let ErrorAlertMessage = "Player left game. Oops!"
let ErrorAlertDismissActionTitle = "Dismiss"

let GameLobbyMainTitle = "Multiplayer"
let GameLobbyMainButtonTitleBrowsing = "Refresh"
let GameLobbyMainButtonTitleAdvertising = "Race"

let yellowColor = UIColor(red: 251/255.0, green: 213/255.0, blue: 6/255.0, alpha: 1.0)
let blueColor = UIColor(red: 0/255.0, green: 170/255.0, blue: 181/255.0, alpha: 1.0)
let greenColor = UIColor(red: 168/255.0, green: 191/255.0, blue: 18/255.0, alpha: 1.0)
let orangeColor = UIColor(red: 255/255.0, green: 159/255.0, blue: 0/255.0, alpha: 1.0)
let pinkColor = UIColor(red: 244/255.0, green: 28/255.0, blue: 84/255.0, alpha: 1.0)
let grayColor = UIColor(red: 51/255.0, green: 54/255.0, blue: 61/255.0, alpha: 1.0)
let whiteColor = UIColor.whiteColor()

func degree2radian(degree: CGFloat) -> CGFloat {
    return CGFloat(M_PI) * degree / 180
}