//
//  iOS_CreditsViewController.swift
//  VelovedGame
//
//  Created by PartyMan on 7/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

class iOS_CreditsViewController: iOS_CustomViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var devTitle: UILabel!
    @IBOutlet weak var devName: UILabel!
    @IBOutlet weak var designTitle: UILabel!
    @IBOutlet weak var designName: UILabel!
    @IBOutlet weak var mentorTitle: UILabel!
    @IBOutlet weak var mentorName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.removeConstraints(self.view.constraints())

        logo.setTranslatesAutoresizingMaskIntoConstraints(false)
        logo.contentMode = UIViewContentMode.ScaleAspectFit

        let viewMap = ["logo" : logo,
            "devTitle" : devTitle,
            "devName" : devName,
            "designTitle" : designTitle,
            "designName" : designName,
            "mentorTitle" : mentorTitle,
            "mentorName" : mentorName]

        let hLogo = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[logo]-10-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hLogo)

        let vLogo = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[logo]-bottomSpacing-|",
            options: nil,
            metrics: ["bottomSpacing" : view.frame.height * 4/7],
            views: viewMap)
        NSLayoutConstraint.activateConstraints(vLogo)

        let vMetrics = ["labelSpacing" : view.frame.height * 4/7 * 1/10]
        let vLabels = NSLayoutConstraint.constraintsWithVisualFormat("V:[logo]-labelSpacing-[devTitle]-[devName]-labelSpacing-[designTitle]-[designName]-labelSpacing-[mentorTitle]-[mentorName]",
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: vMetrics,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(vLabels)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        devTitle.font = UIFont(name: DefaultAppFontNameUltraLight, size: 30)
        designTitle.font = UIFont(name: DefaultAppFontNameUltraLight, size: 30)
        mentorTitle.font = UIFont(name: DefaultAppFontNameUltraLight, size: 30)

        devTitle.textColor = blueColor
        designTitle.textColor = pinkColor
        mentorTitle.textColor = greenColor

        devName.font = UIFont(name: DefaultAppFontNameLight, size: 30)
        designName.font = UIFont(name: DefaultAppFontNameLight, size: 30)
        mentorName.font = UIFont(name: DefaultAppFontNameLight, size: 30)

        devName.textColor = grayColor
        designName.textColor = grayColor
        mentorName.textColor = grayColor
    }

}
