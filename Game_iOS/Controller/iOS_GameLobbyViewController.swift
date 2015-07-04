//
//  iOS_GameLobbyViewController.swift
//  VelovedGame
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon
import MultipeerConnectivity

enum GameInvitationStatus {
    case Pending
    case Accepted
}

class iOS_GameLobbyViewController: iOS_CustomViewController {


    let peerGridCellReuseIdentifier = "idCell"

    var mode: MPCControllerMode

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var peerGrid: UICollectionView!

    let peerGridInterItemSpacing: CGFloat = 10
    let peerGridLineSpacing: CGFloat = 10
    let peerGridInset: CGFloat = 10

    init(mode: MPCControllerMode) {
        self.mode = mode

        super.init(nibName: "iOS_GameLobbyViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.removeConstraints(self.view.constraints())

        configureMainTitle()
        configurePeerGrid()
        configureMainButton()

        view.backgroundColor = UIColor.whiteColor()
        mainTitle.backgroundColor = UIColor.whiteColor()

        mainTitle.setTranslatesAutoresizingMaskIntoConstraints(false)
        mainButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        peerGrid.setTranslatesAutoresizingMaskIntoConstraints(false)

        let viewMap = [ "mainTitle" : mainTitle, "mainButton" : mainButton, "peerGrid" : peerGrid]

        view.addConstraint(NSLayoutConstraint(item: peerGrid,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: peerGrid,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1.0,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: peerGrid,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: peerGrid,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1.0,
            constant: 0.0))

        let hPeerGrid = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[peerGrid]-0-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hPeerGrid)

        let hMainTitle = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[mainTitle]-10-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hMainTitle)

        view.addConstraint(NSLayoutConstraint(item: mainTitle,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.1,
            constant: 0.0))

        let hMainButton = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[mainButton]-10-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hMainButton)

        view.addConstraint(NSLayoutConstraint(item: mainButton,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.1,
            constant: 0.0))

        let hMetrics = ["topSpacing" : view.frame.height * 0.05, "bottomSpacing" : view.frame.height * 0.05]
        let hSpacing = NSLayoutConstraint.constraintsWithVisualFormat("V:[mainTitle]-topSpacing-[peerGrid]",
            options: nil,
            metrics: hMetrics,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hSpacing)

        let hSpacing2 = NSLayoutConstraint.constraintsWithVisualFormat("V:[peerGrid]-bottomSpacing-[mainButton]",
            options: nil,
            metrics: hMetrics,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hSpacing2)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        enableButton()
        MPCController.sharedMPCController.delegate = self

        switch mode {
        case .Advertising:
            MPCController.sharedMPCController.startAdvertising()
        case .Browsing:
            MPCController.sharedMPCController.startJoining()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let _ = errorCode {
            switch errorCode! {
            case .PlayerLeftGame:
                showErrorMessage()
            }
        }
    }

    func configureMainTitle() {
        mainTitle.textAlignment = NSTextAlignment.Center
        mainTitle.font = UIFont(name: DefaultAppFontNameLight, size: 40)
        mainTitle.textColor = pinkColor
        mainTitle.text = GameLobbyMainTitle

    }

    func configurePeerGrid() {

        peerGrid.registerClass(iOS_PeerView.self, forCellWithReuseIdentifier: peerGridCellReuseIdentifier)
        peerGrid.dataSource = self
        peerGrid.delegate = self
        peerGrid.scrollEnabled = false
        peerGrid.backgroundColor = UIColor.whiteColor()
    }

    func configureMainButton() {

        mainButton.setValue(10, forKeyPath: "layer.cornerRadius")
        mainButton.setValue(true, forKeyPath: "layer.masksToBounds")

        switch mode {
        case .Browsing:

            var attributedString = NSMutableAttributedString(string: GameLobbyMainButtonTitleBrowsing)
            attributedString.addAttribute(NSFontAttributeName,
                value: UIFont(name: DefaultAppFontNameLight, size: 40)!,
                range: NSRange(location: 0, length: countElements(GameLobbyMainButtonTitleBrowsing)))

            attributedString.addAttribute(NSForegroundColorAttributeName,
                value: grayColor,
                range: NSRange(location: 0, length: countElements(GameLobbyMainButtonTitleBrowsing)))

            mainButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
            mainButton.backgroundColor = yellowColor

        case .Advertising:

            var attributedString = NSMutableAttributedString(string: GameLobbyMainButtonTitleAdvertising)
            attributedString.addAttribute(NSFontAttributeName,
                value: UIFont(name: DefaultAppFontNameLight, size: 40)!,
                range: NSRange(location: 0, length: countElements(GameLobbyMainButtonTitleAdvertising)))

            attributedString.addAttribute(NSForegroundColorAttributeName,
                value: grayColor,
                range: NSRange(location: 0, length: countElements(GameLobbyMainButtonTitleAdvertising)))

            mainButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)

            var aattributedString = NSMutableAttributedString(string: GameLobbyMainButtonTitleAdvertising)
            aattributedString.addAttribute(NSFontAttributeName,
                value: UIFont(name: DefaultAppFontNameLight, size: 40)!,
                range: NSRange(location: 0, length: countElements(GameLobbyMainButtonTitleAdvertising)))

            aattributedString.addAttribute(NSForegroundColorAttributeName,
                value: grayColor.colorWithAlphaComponent(0.5),
                range: NSRange(location: 0, length: countElements(GameLobbyMainButtonTitleAdvertising)))

            mainButton.setAttributedTitle(aattributedString, forState: UIControlState.Disabled)

            mainButton.backgroundColor = grayColor.colorWithAlphaComponent(0.2)
            mainButton.enabled = false
        }
    }

    func enableButton() {
        let connectPeersCount = MPCController.sharedMPCController.peersWithStatus(.Connected).count

        if self.mode == .Advertising {
            if connectPeersCount >= 2 {
                self.mainButton.enabled = true
                mainButton.backgroundColor = yellowColor
            } else {
                self.mainButton.enabled = false
                mainButton.backgroundColor = grayColor.colorWithAlphaComponent(0.2)
            }
        }
    }

    func showErrorMessage() {
        let errorAlert = iOS_CustomAlertController.getErrorAlertController()
        self.presentViewController(errorAlert, animated: true, completion: nil)
    }
}

extension iOS_GameLobbyViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(peerGridCellReuseIdentifier, forIndexPath: indexPath) as iOS_PeerView
        cell.setBadgeBackgroundColor(-2)

        var peerName: String
        var peerStatus: String

        if indexPath.row == 0 {
            let localPeerID = MPCController.sharedMPCController.peerID
            peerName = localPeerID.displayName
            peerStatus = MPCController.sharedMPCController.peers[localPeerID]!.description
        }else {
            if indexPath.row < MPCController.sharedMPCController.peersSorted.count {
                let remotePeerID = MPCController.sharedMPCController.peersSorted[indexPath.row]
                peerName = remotePeerID.displayName
                peerStatus = MPCController.sharedMPCController.peers[remotePeerID]!.description

            } else {
                peerName = "Rider"
                peerStatus = "-"
            }
        }

        if indexPath.row < MPCController.sharedMPCController.peersSorted.count {
            let aPeer = MPCController.sharedMPCController.peersSorted[indexPath.row]

            if .Connected == MPCController.sharedMPCController.peers[aPeer]! {
                let peerPrecedence = MPCController.sharedMPCController.peerPrecedence(aPeer)
                cell.setBadgeBackgroundColor(peerPrecedence)
            } else {
                cell.setBadgeBackgroundColor(-1)
            }
        }


        cell.peerNameLabel.text = peerName
        cell.peerStatusLabel.text = peerStatus

        return cell
    }
}

extension iOS_GameLobbyViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

extension iOS_GameLobbyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath: NSIndexPath) -> CGSize {

        let itemSize = (peerGrid.bounds.width - (peerGridInset * 2) - peerGridInterItemSpacing) / 2

        return CGSize(width: itemSize, height: itemSize)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return peerGridLineSpacing
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return peerGridInterItemSpacing
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: peerGridInset, left: peerGridInset, bottom: peerGridInset, right: peerGridInset)
        return inset
    }
}

extension iOS_GameLobbyViewController: MPCControllerDelegate {

    func didUpdatePeers() {

        dispatch_async(dispatch_get_main_queue()) {
            self.peerGrid.reloadData()
            self.enableButton()
        }
    }

    func didReceiveMessage(msg: MPCMessage) {
        switch msg.event {
        case .ShowGameViewController:
            MPCController.sharedMPCController.operationMode = .SendAndQueueReceive
            showGameViewController()
        default:
            println("WARNING: \(self)  - Following message was ignored \(msg)")
        }
    }

    func peerIsConnecting(peer: MCPeerID) {
        // Do nothing
    }
    func peerDidConnect(peer: MCPeerID) {
        // Do nothing
    }

    func peerDidNotConnect(peer: MCPeerID) {
        // Do nothing
    }
}

extension iOS_GameLobbyViewController {

    @IBAction func mainButtonAction(sender: UIButton) {
        switch mode {
        case .Browsing:

            showRefreshView()

            MPCController.sharedMPCController.stopBrowsing()
            MPCController.sharedMPCController.startJoining()
        case .Advertising:

            MPCController.sharedMPCController.stopAdvertising()

            MPCController.sharedMPCController.operationMode = .SendAndQueueReceive
            let showGameViewControllerMsg = MPCMessage.getShowGameViewControllerMessage()
            MPCController.sharedMPCController.sendMessage(showGameViewControllerMsg)
            showGameViewController()
        }
    }

    func showRefreshView() {

        let newSide = min(view.bounds.size.width / 4, view.bounds.size.height / 4)
        let newSize = CGSize(width: newSide, height: newSide)
        let newFrame = CGRect(origin: CGPointZero, size: newSize)
        let refreshLabel = UILabel(frame: newFrame)
        refreshLabel.textAlignment = NSTextAlignment.Center

        refreshLabel.text = "🔃"

        view.addSubview(refreshLabel)
        refreshLabel.center = view.center

        UIView.animateWithDuration(2,
            delay: 0,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { refreshLabel.alpha = 0 },
            completion: { (completion) in refreshLabel.removeFromSuperview() })
    }
    
    func showGameViewController() {
        
        let gameVC = iOS_GameViewController(gameMode: GameMode.MultiPlayer)
        dispatch_async(dispatch_get_main_queue()) {
            self.showViewController(gameVC, sender: self)
        }
    }
    
}