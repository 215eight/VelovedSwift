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

    let menuCellIdentifier = "menuCell"

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

    override func loadView() {
        super.loadView()
        tableView.registerNib(UINib(nibName: "iOS_MenuTableViewCell", bundle: nil), forCellReuseIdentifier: menuCellIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
    }

    override func viewWillAppear(animated: Bool) {
        if let selectedRow = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(selectedRow, animated: false)
        }
        MPCController.destroySharedMPCController()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

    override func shouldAutorotate() -> Bool {
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
        let cell = tableView.dequeueReusableCellWithIdentifier(menuCellIdentifier, forIndexPath: indexPath) as iOS_MenuTableViewCell

        if indexPath.row == 0 {
            logoTableViewCell(cell)
        }else {
            menuTableViewCell(cell, indexPath: indexPath)
        }

        return cell
    }

    func logoTableViewCell(cell: iOS_MenuTableViewCell) {
        let backgroundImage = UIImage(named: "veloved_logoline.png")
        let backgroundImageView = UIImageView(image: backgroundImage!)
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFit
        backgroundImageView.setTranslatesAutoresizingMaskIntoConstraints(false)

        cell.contentView.addSubview(backgroundImageView)

        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[backgroundImageView]-10-|",
            options: nil,
            metrics: nil,
            views: ["backgroundImageView":backgroundImageView])

        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[backgroundImageView]-10-|",
            options: nil,
            metrics: nil,
            views: ["backgroundImageView":backgroundImageView])

        NSLayoutConstraint.activateConstraints(horizontalConstraints)
        NSLayoutConstraint.activateConstraints(verticalConstraints)
    }

    func menuTableViewCell(cell: iOS_MenuTableViewCell, indexPath: NSIndexPath) {
        cell.menuButton.setTitle(menuOptions.menu[indexPath.row], forState: UIControlState.Normal)

        cell.menuButton.setTitleColor(grayColor, forState: UIControlState.Normal)
        cell.menuButton.setTitleColor(whiteColor, forState: UIControlState.Highlighted)

        cell.menuButton.titleLabel?.font = UIFont(name: DefaultAppFontNameLight, size: 35)
        cell.menuButton.titleLabel?.textAlignment = .Center

        cell.menuButton.backgroundColor = menuTableViewCellColor(indexPath)

        cell.menuButton.tag = indexPath.row
        cell.menuButton.addTarget(self, action: "cellButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    func menuTableViewCellColor(indexPath: NSIndexPath) -> UIColor {
        switch indexPath.row {
        case 1:
            return blueColor
        case 2:
            return greenColor
        case 3:
            return orangeColor
        case 4:
            return pinkColor
        default:
            return grayColor
        }
    }

    func cellButtonPressed(sender: UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        tableView(tableView, didSelectRowAtIndexPath: indexPath)
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

    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row == 0 ? false : true
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
            showViewController(gameLobbyVC, sender: self)
        }

        // Join Multiplayer Game
        if menuOptions.menu[indexPath.row] == menuOptions.menu[3] {
            let gameLobbyVC = iOS_GameLobbyViewController(mode: MPCControllerMode.Browsing)
            showViewController(gameLobbyVC, sender: self)
        }
        
        // Credits
        if menuOptions.menu[indexPath.row] == menuOptions.menu[4] {
            let creditsVC = iOS_CreditsViewController(nibName: "iOS_CreditsViewController", bundle: nil)
            showViewController(creditsVC, sender: self)
        }
    }
    
}
