//
//  iOS_StartMenuViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import SnakeCommon

class iOS_StartMenuViewController: UITableViewController {

    var menuOptions = MenuOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension iOS_StartMenuViewController: UITableViewDataSource {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.getMenu().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = menuOptions.getMenu()[indexPath.row]
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.textAlignment = NSTextAlignment.Center

        return cell
    }
}

extension iOS_StartMenuViewController: UITableViewDelegate {

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        // Single Player Game
        if menuOptions.getMenu()[indexPath.row] == menuOptions.getMenu()[0] {
            let snakeVC = iOS_SnakeGameViewController(gameMode: SnakeGameMode.SinglePlayer)
            showViewController(snakeVC, sender: self)
        }

        // Host Multiplayer Game
        if menuOptions.getMenu()[indexPath.row] == menuOptions.getMenu()[1] {

            let gameLobbyVC = iOS_GameLobbyViewController(mode: MPCControllerMode.Advertising)
            gameLobbyVC.title = "Waiting..."
            showViewController(gameLobbyVC, sender: self)
        }

        // Join Multiplayer Game
        if menuOptions.getMenu()[indexPath.row] == menuOptions.getMenu()[2] {
            let gameLobbyVC = iOS_GameLobbyViewController(mode: MPCControllerMode.Browsing)
            gameLobbyVC.title = "Waiting..."
            showViewController(gameLobbyVC, sender: self)
        }

        // Settings
        if menuOptions.getMenu()[indexPath.row] == menuOptions.getMenu()[3] {
            println("Settings")
        }
    }

}