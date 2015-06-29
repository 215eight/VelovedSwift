//
//  iOS_StartMenuViewController.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

class iOS_StartMenuViewController: UITableViewController {

    var menuOptions = MenuOptions()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        clearsSelectionOnViewWillAppear = true
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.scrollEnabled = false
        self.tableView.allowsMultipleSelection = false
        self.tableView.scrollToNearestSelectedRowAtScrollPosition(UITableViewScrollPosition.Top, animated: true)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
    }

    override func viewWillAppear(animated: Bool) {
        MPCController.destroySharedMPCController()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension iOS_StartMenuViewController: UITableViewDataSource {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.numberOfMenuOptions
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = menuOptions.menu[indexPath.row]
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 30)

        return cell
    }
}

extension iOS_StartMenuViewController: UITableViewDelegate {

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let rowHeight = tableView.bounds.height / CGFloat(menuOptions.numberOfMenuOptions + 2)

        if indexPath.row == 0 {
            return rowHeight * 3
        } else {
            return rowHeight
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        // Single Player Game
        if menuOptions.menu[indexPath.row] == menuOptions.menu[1] {
            let gameVC = iOS_GameViewController(gameMode: GameMode.SinglePlayer)
            showViewController(gameVC, sender: self)
        }

        // Host Multiplayer Game
        if menuOptions.menu[indexPath.row] == menuOptions.menu[2] {

            let gameLobbyVC = iOS_GameLobbyViewController(mode: MPCControllerMode.Advertising)
            gameLobbyVC.title = "Waiting..."
            showViewController(gameLobbyVC, sender: self)
        }

        // Join Multiplayer Game
        if menuOptions.menu[indexPath.row] == menuOptions.menu[3] {
            let gameLobbyVC = iOS_GameLobbyViewController(mode: MPCControllerMode.Browsing)
            gameLobbyVC.title = "Waiting..."
            showViewController(gameLobbyVC, sender: self)
        }

        // Credits
        if menuOptions.menu[indexPath.row] == menuOptions.menu[4] {
            println("Credits")
        }
    }

}