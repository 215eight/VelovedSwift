//
//  iOS_MPCFoundPeersController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/21/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import GameCommon
import MultipeerConnectivity

class iOS_MPCGameLobbyBrowsingController: NSObject {

    private let alertTitle = "Finding Hosts"
    private let alertMessage = ""

    private let joinActionTitle = "Join"
    private let cancelActionTitle = "Cancel"

    var alertController: UIAlertController

    private var selectedTextField: UITextField?

    override init(){
        alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)

        super.init()

        self.addTextFields()
        self.addActions()

    }

    func addTextFields() {

        func textFieldConfigurtaionHandler(index: Int) -> ((UITextField!) -> Void) {
            func textFieldConfig(textField: UITextField!) -> Void {
                textField.tag = index
                textField.placeholder = "Host"
                textField.text = ""
                textField.textAlignment = NSTextAlignment.Center
                textField.textColor = UIColor.blackColor()
                textField.font = UIFont(name: "HelveticaNeue-Light", size:12)
                textField.delegate = self
            }

            return textFieldConfig
        }

        for index in 0..<5 {
            alertController.addTextFieldWithConfigurationHandler(textFieldConfigurtaionHandler(index))
        }
    }

    func addActions() {

        let cancelAction = UIAlertAction(title: cancelActionTitle,
            style: UIAlertActionStyle.Cancel,
            handler:{ (alertAction) in
                MPCController.sharedMPCController.stopBrowsing()
        })
        alertController.addAction(cancelAction)

        let joinAction = UIAlertAction(title: joinActionTitle,
            style: UIAlertActionStyle.Default,
            handler: { (alertAction) in
                if let _ = self.selectedTextField {
                    let foundPeer = self.getFoundPeers()[self.selectedTextField!.tag]
                    MPCController.sharedMPCController.invitePeer(foundPeer)
                    MPCController.sharedMPCController.stopBrowsing()
                }
        })
        alertController.addAction(joinAction)
    }

    func getFoundPeers() -> [MCPeerID] {
        var foundPeers = [MCPeerID]()

        for (peer, status) in MPCController.sharedMPCController.peers {
            if status == MPCPeerIDStatus.Found {
                foundPeers.append(peer)
            }
        }

        return foundPeers
    }

    func updateTextFields() {

        alertController.textFields?.map() { ($0 as UITextField).text = "" }

        var textFieldGenerator = alertController.textFields?.generate()
        for (peer, status) in MPCController.sharedMPCController.peers {
            if status == MPCPeerIDStatus.Found {
                if let textField = textFieldGenerator?.next() as? UITextField {
                    textField.text = peer.displayName
                }
            }
        }
    }
}

extension iOS_MPCGameLobbyBrowsingController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        selectedTextField?.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        selectedTextField?.backgroundColor = UIColor.whiteColor()
        selectedTextField = textField
        selectedTextField?.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        selectedTextField?.backgroundColor = UIColor.lightGrayColor()
        return false
    }

}