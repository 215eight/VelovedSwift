//
//  iOS_MPCFoundPeersController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/21/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import SnakeCommon

class iOS_MPCFoundPeersController: NSObject {

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

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateTextFields",
            name: MPCFoundPeersDidChangeNotification,
            object: MPCController.sharedMPCController)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: MPCFoundPeersDidChangeNotification,
            object: MPCController.sharedMPCController)
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
                if let peerIndex = self.selectedTextField?.tag {
                    if peerIndex <= MPCController.sharedMPCController.getFoundPeers().count {
                        let peer = MPCController.sharedMPCController.getFoundPeers()[peerIndex]
                        MPCController.sharedMPCController.inivitePeer(peer)
                        MPCController.sharedMPCController.stopBrowsing()
                    }
                }
        })
        alertController.addAction(joinAction)
    }

    func updateTextFields() {

        alertController.textFields?.map() { ($0 as UITextField).text = "" }

        for (index, aPeer) in enumerate(MPCController.sharedMPCController.getFoundPeers()) {
            if index < alertController.textFields?.count {
                let textField = alertController.textFields![index] as UITextField
                textField.text = aPeer.displayName
            }
        }
    }
}

extension iOS_MPCFoundPeersController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        selectedTextField?.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        selectedTextField?.backgroundColor = UIColor.whiteColor()
        selectedTextField = textField
        selectedTextField?.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        selectedTextField?.backgroundColor = UIColor.lightGrayColor()
        return false
    }

}