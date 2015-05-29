//
//  OSX_GameLobbyViewController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/22/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa
import GameCommon
import MultipeerConnectivity

class OSX_GameLobbyViewController: NSViewController {

    weak var windowContainer: OSX_MainWindowController?

    @IBOutlet weak var modeControl: NSSegmentedControl!
    @IBOutlet weak var msgField: NSTextField!
    @IBOutlet weak var peersTableView: NSTableView!
    @IBOutlet weak var messagesTableView: NSTableView!
    @IBOutlet weak var startGameButton: NSButton!
    var peersTVC: PeersTVC!
    var messagesTVC: MessagesTVC!

    override func viewDidLoad() {
        super.viewDidLoad()

        peersTVC = PeersTVC()
        peersTableView.setDataSource(peersTVC)
        peersTableView.setDelegate(peersTVC)

        messagesTVC = MessagesTVC()
        messagesTableView.setDataSource(messagesTVC)

    }

    func configureMPCController() {

        switch modeControl.selectedSegment {
        case 0: // Idle
            MPCController.sharedMPCController.stopAdvertising()
            MPCController.sharedMPCController.stopBrowsing()
        case 1: // Advertising
            MPCController.sharedMPCController.startAdvertising()
        case 2: // Browsing
            MPCController.sharedMPCController.startBrowsing()
        case 3: // Destroy
            MPCController.destroySharedMPCController()
        default:
            break
        }

        if modeControl.selectedSegment != 3 {
            MPCController.sharedMPCController.delegate = self
        }
    }

    func configureStartGameButton() {
        if MPCController.sharedMPCController.getConnectedPeers().isEmpty {
            self.startGameButton.enabled = false
        } else {
            self.startGameButton.enabled = true
        }
    }

    override func viewWillAppear() {
        configureMPCController()
        configureStartGameButton()
    }

    override func viewWillDisappear() {

        MPCController.sharedMPCController.delegate = nil
        MPCController.sharedMPCController.stopAdvertising()
        MPCController.sharedMPCController.stopBrowsing()
        windowContainer?.gameLobbyVC = nil
        windowContainer = nil
    }


}

extension OSX_GameLobbyViewController {
    
    @IBAction func toggleMode(sender: NSSegmentedCell) {
        configureMPCController()
        configureStartGameButton()
    }

    @IBAction func invitePeer(sender: NSButton) {
        if let peer = peersTVC.selectedPeer {
            if MPCController.sharedMPCController.peers[peer] == MPCPeerIDStatus.Found {
                MPCController.sharedMPCController.inivitePeer(peer)
            }
        }
    }

    @IBAction func sendMsg(sender: NSButton) {
        let msgBody = msgField.stringValue
        let msg = MPCMessage.getTestMessage(msgBody)
        MPCController.sharedMPCController.sendMessage(msg)
    }


    @IBAction func startGame(sender: NSButton) {
        let showGameViewControllerMsg = MPCMessage.getShowGameViewControllerMessage()
        MPCController.sharedMPCController.sendMessage(showGameViewControllerMsg)
        showGameVC()
    }

    func updatePeers() {
        dispatch_async(dispatch_get_main_queue()) {
            self.peersTableView.reloadData()
        }
        configureStartGameButton()
    }

    func showTestMessage(message: MPCMessage) {
        var newMsg = [String:String]()

        newMsg[MPCMessageKey.Sender.rawValue] = message.sender.displayName
        newMsg[MPCMessageKey.Receiver.rawValue] = MPCController.sharedMPCController.peerID.displayName
        if let body = message.body {
            newMsg[MPCMessageKey.TestMsgBody.rawValue] = body[MPCMessageKey.TestMsgBody.rawValue] as? String
        }

        messagesTVC.messages.append(newMsg)

        dispatch_async(dispatch_get_main_queue()) {
            self.messagesTableView.reloadData()
        }
    }

    func showGameVC() {
        dispatch_async(dispatch_get_main_queue()) {
            self.windowContainer!.showMultiplayerGameVC()
        }
    }
}

extension OSX_GameLobbyViewController: MPCControllerDelegate {

    func didUpdatePeers() {
        updatePeers()
    }

    func didReceiveMessage(msg: MPCMessage) {
        switch msg.event{
        case .TestMsg:
            showTestMessage(msg)
        case .ShowGameViewController:
            showGameVC()
        default:
            break
        }
    }
}

class PeersTVC: NSObject {

    var selectedPeer: MCPeerID?
}

extension PeersTVC: NSTableViewDataSource {

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return MPCController.sharedMPCController.peers.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {

        let peer = MPCController.sharedMPCController.peers.keys.array[row]
        var value = MPCController.sharedMPCController.peers[peer]!

        if tableColumn?.identifier == "peerName" {
            return peer.displayName
        } else {
            return value.description
        }
    }
}

extension PeersTVC: NSTableViewDelegate {

    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        selectedPeer = MPCController.sharedMPCController.peers.keys.array[row]
        return true
    }
}

class MessagesTVC: NSObject {

    var messages = [[ String : String ]]()
}

extension MessagesTVC: NSTableViewDataSource {

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return messages.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {

        let rowContent = messages[row]
        return rowContent[tableColumn!.identifier]!
    }
}