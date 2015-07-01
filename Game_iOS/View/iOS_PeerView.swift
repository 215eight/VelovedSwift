//
//  iOS_PeerInvite.swift
//  VelovedGame
//
//  Created by eandrade on 4/23/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

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
        peerNameLabel.font = UIFont(name: DefaultAppFontName , size: 18.0)
        peerNameLabel.text = "Player"
        peerNameLabel.textAlignment = NSTextAlignment.Center
        peerNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        peerNameLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        peerNameLabel.numberOfLines = 2
        addSubview(peerNameLabel)

        peerStatusLabel = UILabel(frame: self.bounds)
        peerStatusLabel.font = UIFont(name: DefaultAppFontNameLight, size: 16.0)
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
            backgroundColor = blueColor
        case 1:
            backgroundColor = greenColor
        case 2:
            backgroundColor = orangeColor
        case 3:
            backgroundColor = pinkColor
        default:
            backgroundColor = UIColor.clearColor()
        }
    }
}