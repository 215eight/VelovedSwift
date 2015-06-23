//
//  iOS_GameLobbyViewController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/20/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import GameCommon
import MultipeerConnectivity

enum GameInvitationStatus {
    case Pending
    case Accepted
}

class iOS_GameLobbyViewController: iOS_CustomViewController {


    let mainButtonTitleBrowsing = "Refresh"
    let mainButtonTitleAdvertising = "Let's Race!"
    let peerGridCellReuseIdentifier = "peerCell"

    var mode: MPCControllerMode

    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var peerGrid: UICollectionView!

    let peerGridInterItemSpacing: CGFloat = 10
    let peerGridLineSpacing: CGFloat = 10
    let peerGridInset: CGFloat = 10

    init(mode: MPCControllerMode) {
        self.mode = mode

        super.init(nibName: "iOS_GameLobbyViewController", bundle: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        configurePeerGrid()
        configureMainButton()
        MPCController.sharedMPCController.delegate = self

        switch mode {
        case .Advertising:
            MPCController.sharedMPCController.startAdvertising()
        case .Browsing:
            MPCController.sharedMPCController.startJoining()
        }
    }

    func configurePeerGrid() {

        peerGrid.registerClass(iOS_PeerView.self, forCellWithReuseIdentifier: peerGridCellReuseIdentifier)
        peerGrid.dataSource = self
        peerGrid.delegate = self
        peerGrid.scrollEnabled = false
    }

    func configureMainButton() {
        switch mode {
        case .Browsing:
            mainButton.setTitle(mainButtonTitleBrowsing, forState: .Normal)
            mainButton.setTitle(mainButtonTitleBrowsing, forState: .Highlighted)
            mainButton.setTitle(mainButtonTitleBrowsing, forState: .Selected)
        case .Advertising:
            mainButton.setTitle(mainButtonTitleAdvertising, forState: .Normal)
            mainButton.setTitle(mainButtonTitleAdvertising, forState: .Highlighted)
            mainButton.setTitle(mainButtonTitleAdvertising, forState: .Selected)
            mainButton.enabled = false
        }
    }

    func showErrorMessage() {

        let errorAlert = iOS_CustomAlertController.getErrorAlertController()
        self.presentViewController(errorAlert, animated: true, completion: nil)

//        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
//                errorLabel.alpha = 1.0
//            }
//            , completion: {
//                (finished: Bool) -> Void in
//
//                UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
//                    errorLabel.alpha = 0.0
//                    }, completion: { (finished: Bool) -> Void in errorLabel.removeFromSuperview() })
//        })


    }
}

extension iOS_GameLobbyViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(peerGridCellReuseIdentifier, forIndexPath: indexPath) as iOS_PeerView
        // Configure the cell

        var peerName: String
        var peerStatus: String

        if indexPath.item < MPCController.sharedMPCController.peers.count {
            let existingPeer = MPCController.sharedMPCController.peersSorted[indexPath.item]
            peerName = existingPeer.displayName
            peerStatus = MPCController.sharedMPCController.peers[existingPeer]!.description
            cell.setCellBackgroundColor(indexPath.item)
        } else {
            peerName = "Rider \(indexPath.item + 1)"
            peerStatus = "-"
            cell.setCellBackgroundColor(-1)
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

        let connectPeersCount = MPCController.sharedMPCController.peersWithStatus(.Connected).count

        dispatch_async(dispatch_get_main_queue()) {
            self.peerGrid.reloadData()

            if self.mode == .Advertising {
                if connectPeersCount >= 2 {
                    self.mainButton.enabled = true
                } else {
                    self.mainButton.enabled = false
                }
            }
        }

    }

    func didReceiveMessage(msg: MPCMessage) {
        switch msg.event {
        case .ShowGameViewController:
            MPCController.sharedMPCController.operationMode = .SendAndQueueReceive
            showGameViewController()
        case .PeerDidNotConnect:
            println("Ignore")
        default:
            assertionFailure("Game Lobby received invalid messege")
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

    func showGameViewController() {

        let gameVC = iOS_GameViewController(gameMode: GameMode.MultiPlayer)
        dispatch_async(dispatch_get_main_queue()) {
            self.showViewController(gameVC, sender: self)
        }
    }

}
