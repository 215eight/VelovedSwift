//
//  iOS_PeerInvite.swift
//  SnakeSwift
//
//  Created by eandrade on 4/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class iOS_PeerInvite: UIView {

    var peerNameLabel: UILabel!
    var statusLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        peerNameLabel = UILabel(frame: self.bounds)
        peerNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        peerNameLabel.text = "Player"
        peerNameLabel.textAlignment = NSTextAlignment.Center
        peerNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(peerNameLabel)

        statusLabel = UILabel(frame: self.bounds)
        statusLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        statusLabel.text = "status"
        statusLabel.textAlignment = NSTextAlignment.Center
        statusLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(statusLabel)

        let viewMap = ["peerNameLabel" : peerNameLabel,
                            "statusLabel" : statusLabel]

        let hPeerNameLabelConst = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[peerNameLabel]-|",
            options: nil,
            metrics: nil,
            views: viewMap)

        let hStatusLabelConst = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[statusLabel]-|",
            options: nil,
            metrics: nil,
            views: viewMap)

        let vConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[peerNameLabel]-[statusLabel]-|",
            options: nil,
            metrics: nil,
            views: viewMap)

        NSLayoutConstraint.activateConstraints(hPeerNameLabelConst)
        NSLayoutConstraint.activateConstraints(hStatusLabelConst)
        NSLayoutConstraint.activateConstraints(vConstraint)
    }
}