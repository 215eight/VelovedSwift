//
//  OSX_GameLobbyViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/22/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Cocoa
import SnakeCommon
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
        case 0: // Off
            MPCController.sharedMPCController.stopAdvertising()
            MPCController.sharedMPCController.stopBrowsing()
        case 1: // Advertising
            MPCController.sharedMPCController.startAdvertising()
        case 2: // Browsing
            MPCController.sharedMPCController.startBrowsing()
        default:
            break
        }

        MPCController.sharedMPCController.delegate = self
    }

    override func viewWillAppear() {
        configureMPCController()
    }

    override func viewWillDisappear() {

        MPCController.sharedMPCController.delegate = nil
        MPCController.sharedMPCController.stopAdvertising()
        MPCController.sharedMPCController.stopBrowsing()
        windowContainer?.gameLobby = nil
        windowContainer = nil
    }


}

extension OSX_GameLobbyViewController {
    
    @IBAction func toggleMode(sender: NSSegmentedCell) {
        configureMPCController()

        sender.selectedSegment == 1 ? (startGameButton.enabled = true) : (startGameButton.enabled = false)
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
        if modeControl.selectedSegment == 1 {
            let setUpGameMsg = MPCMessage.getSetUpGameMessage()
            MPCController.sharedMPCController.sendMessage(setUpGameMsg)
            showSnakeGameVC()
        }
    }

    func updatePeers() {
        dispatch_async(dispatch_get_main_queue()) {
            self.peersTableView.reloadData()
        }
    }

    func showTestMessage(message: MPCMessage) {
        var newMsg = [String:String]()

        newMsg[MPCMessageKey.Sender.rawValue] = message.sender
        newMsg[MPCMessageKey.Receiver.rawValue] = MPCController.sharedMPCController.peerID.displayName
        if let body = message.body {
            newMsg[MPCMessageKey.TestMsgBody.rawValue] = body[MPCMessageKey.TestMsgBody.rawValue] as? String
        }

        messagesTVC.messages.append(newMsg)

        dispatch_async(dispatch_get_main_queue()) {
            self.messagesTableView.reloadData()
        }
    }

    func showSnakeGameVC() {
        dispatch_async(dispatch_get_main_queue()){
            switch self.modeControl.selectedSegment {
            case 0:
                self.windowContainer?.showMultiplayerSlaveSnakeGameVC()
            case 1: // Advertising
                self.windowContainer?.showMultiplayerMasterSnakeGameVC()
            case 2: // Browsing
                self.windowContainer?.showMultiplayerSlaveSnakeGameVC()
            default:
                break
            }
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
        case .SetUpGame:
            showSnakeGameVC()
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