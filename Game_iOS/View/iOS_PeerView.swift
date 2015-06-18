//
//  iOS_PeerInvite.swift
//  GameSwift
//
//  Created by eandrade on 4/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class iOS_PeerView: UICollectionViewCell {

    var peerNameLabel: UILabel!
    var peerStatusLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }

    func viewInit() {

        peerNameLabel = UILabel(frame: self.bounds)
        peerNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        peerNameLabel.text = "Player"
        peerNameLabel.textAlignment = NSTextAlignment.Center
        peerNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        peerNameLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        peerNameLabel.numberOfLines = 0
        addSubview(peerNameLabel)

        peerStatusLabel = UILabel(frame: self.bounds)
        peerStatusLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        peerStatusLabel.text = "status"
        peerStatusLabel.textAlignment = NSTextAlignment.Center
        peerStatusLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(peerStatusLabel)

        let viewMap = ["peerNameLabel" : peerNameLabel,
                            "peerStatusLabel" : peerStatusLabel]

        let hPeerNameLabelConst = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[peerNameLabel]-|",
            options: nil,
            metrics: nil,
            views: viewMap)

        let hPeerStatusLabelConst = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[peerStatusLabel]-|",
            options: nil,
            metrics: nil,
            views: viewMap)

        let vConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[peerNameLabel]-[peerStatusLabel]-|",
            options: nil,
            metrics: nil,
            views: viewMap)

        NSLayoutConstraint.activateConstraints(hPeerNameLabelConst)
        NSLayoutConstraint.activateConstraints(hPeerStatusLabelConst)
        NSLayoutConstraint.activateConstraints(vConstraint)
    }

    func setCellBackgroundColor(index: Int) {
        switch index {
        case 0:
            backgroundColor = UIColor.greenColor()
        case 1:
            backgroundColor = UIColor.blueColor()
        case 2:
            backgroundColor = UIColor.cyanColor()
        case 3:
            backgroundColor = UIColor.magentaColor()
        default:
            backgroundColor = UIColor.lightGrayColor()
        }
    }
}