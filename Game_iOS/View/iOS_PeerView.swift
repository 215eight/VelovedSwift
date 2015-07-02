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
    private var badge: UIButton!
    private var bikeView: BikeFullView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
        configureConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
        configureConstraints()
    }

    func viewInit() {

        badge = UIButton(frame: self.bounds)
        badge.setValue(10, forKeyPath: "layer.cornerRadius")
        badge.setValue(true, forKeyPath: "layer.masksToBounds")
        setBadgeBackgroundColor(-2)
        addSubview(badge)

        peerNameLabel = UILabel(frame: self.bounds)
        peerNameLabel.font = UIFont(name: DefaultAppFontNameLight , size: 16.0)
        peerNameLabel.textAlignment = NSTextAlignment.Center
        peerNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        peerNameLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        peerNameLabel.numberOfLines = 0
        addSubview(peerNameLabel)

        peerStatusLabel = UILabel(frame: self.bounds)
        peerStatusLabel.font = UIFont(name: DefaultAppFontNameUltraLight, size: 16.0)
        peerStatusLabel.textAlignment = NSTextAlignment.Center
        peerStatusLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(peerStatusLabel)

        bikeView = BikeFullView(frame: self.bounds)
        bikeView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(bikeView)

    }

    func configureConstraints() {

        let viewMap = ["peerNameLabel" : peerNameLabel,
            "peerStatusLabel" : peerStatusLabel,
            "bikeView" : bikeView]

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

        NSLayoutConstraint.activateConstraints(hPeerNameLabelConst)
        NSLayoutConstraint.activateConstraints(hPeerStatusLabelConst)

        self.addConstraint(NSLayoutConstraint(item: peerNameLabel,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.27,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: peerNameLabel,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.TopMargin,
            multiplier: 1.0,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: peerStatusLabel,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.13,
            constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: peerStatusLabel,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: peerNameLabel,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0.0))


    }

    func setBadgeBackgroundColor(index: Int) {
        switch index {
        case 0:
            badge.backgroundColor = blueColor
        case 1:
            badge.backgroundColor = greenColor
        case 2:
            badge.backgroundColor = orangeColor
        case 3:
            badge.backgroundColor = pinkColor
        case -2:
            badge.backgroundColor = grayColor.colorWithAlphaComponent(0.2)
        default:
            badge.backgroundColor = grayColor.colorWithAlphaComponent(0.5)
        }
    }
}