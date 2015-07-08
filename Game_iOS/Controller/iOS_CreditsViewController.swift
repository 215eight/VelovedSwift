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

    @IBOutlet weak var dedication: UILabel!

    @IBOutlet weak var devTitle: UILabel!
    @IBOutlet weak var devName: UILabel!
    @IBOutlet weak var devLinkedIn: UIButton!
    @IBOutlet weak var devGithub: UIButton!

    @IBOutlet weak var designTitle: UILabel!
    @IBOutlet weak var designName: UILabel!
    @IBOutlet weak var designLinkedIn: UIButton!

    @IBOutlet weak var mentorTitle: UILabel!
    @IBOutlet weak var mentorName: UILabel!
    @IBOutlet weak var mentorLinkedIn: UIButton!
    @IBOutlet weak var mentorGithub: UIButton!

    @IBOutlet weak var version: UILabel!

    let linkedInIcon = UIImage(named: "linkedIn.png")
    let githubIcon = UIImage(named: "github.png")

    let buttonLinks = [AppDevLinkedIn,
    AppDevGithub,
    AppDesignLinkedIn,
    AppMentorLinkedIn,
    AppMentorGithub]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.removeConstraints(self.view.constraints())

        let viewMap = ["logo" : logo,
            "dedication" : dedication,
            "devTitle" : devTitle,
            "devName" : devName,
            "devLinkedIn" : devLinkedIn,
            "devGithub" : devGithub,
            "designTitle" : designTitle,
            "designName" : designName,
            "designLinkedIn" : designLinkedIn,
            "mentorTitle" : mentorTitle,
            "mentorName" : mentorName,
            "mentorLinkedIn" : mentorLinkedIn,
            "mentorGithub" : mentorGithub,
            "version" : version]

        dedication.setTranslatesAutoresizingMaskIntoConstraints(false)
        dedication.numberOfLines = 5
        dedication.userInteractionEnabled = false
        dedication.textAlignment = NSTextAlignment.Center
        dedication.text = AppDedication
        dedication.font = UIFont(name: DefaultAppFontNameLightItalic, size: AppDedicationFontSize)

        logo.setTranslatesAutoresizingMaskIntoConstraints(false)
        logo.contentMode = UIViewContentMode.ScaleAspectFit

        let hLogo = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[logo]-10-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hLogo)

        view.addConstraint(NSLayoutConstraint(item: logo,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 2/8,
            constant: 0.0))

        let hDedication = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[dedication]-10-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hDedication)

        let hDevTitle = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[devTitle]-10-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hDevTitle)

        let hDesignTitle = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[designTitle]-10-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hDesignTitle)

        let hMentorTitle = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[mentorTitle]-10-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hMentorTitle)

        view.addConstraint(NSLayoutConstraint(item: devName,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.65,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: designName,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.65,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: mentorName,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.65,
            constant: 0.0))

        let hVersion = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[version]-10-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hVersion)

        //------------------

        view.addConstraint(NSLayoutConstraint(item: devTitle,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.05,
            constant: 0.0))


        view.addConstraint(NSLayoutConstraint(item: designTitle,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.05,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: mentorTitle,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.05,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: devName,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.05,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: designName,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.05,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: mentorName,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.05,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: devGithub,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: devName,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.8,
            constant: 0))

        view.addConstraint(NSLayoutConstraint(item: devGithub,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: devGithub,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0))

        view.addConstraint(NSLayoutConstraint(item: devLinkedIn,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: devName,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.8,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: devLinkedIn,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: devLinkedIn,
            attribute: NSLayoutAttribute.Width,
            multiplier: 1.0,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: designLinkedIn,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: designName,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.8,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: designLinkedIn,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: designLinkedIn,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: mentorLinkedIn,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mentorName,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.8,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: mentorLinkedIn,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mentorLinkedIn,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: mentorGithub,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mentorName,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.8,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: mentorGithub,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mentorGithub,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0.0))

        view.addConstraint(NSLayoutConstraint(item: version,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1.0,
            constant: 10.0))

        let hDev = NSLayoutConstraint.constraintsWithVisualFormat("H:[devGithub]-[devLinkedIn]-[devName]-0-|",
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hDev)

        let hDesign = NSLayoutConstraint.constraintsWithVisualFormat("H:[designLinkedIn]-[designName]-0-|",
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hDesign)

        let hMentor = NSLayoutConstraint.constraintsWithVisualFormat("H:[mentorGithub]-[mentorLinkedIn]-[mentorName]-0-|",
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(hMentor)

        let vLabels = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[logo]-[dedication]-[devTitle]-[devName]-[designTitle]-[designName]-[mentorTitle]-[mentorName]-[version]-10-|",
            options: nil,
            metrics: nil,
            views: viewMap)
        NSLayoutConstraint.activateConstraints(vLabels)

        //----------------------

        devLinkedIn.tag = 0
        devGithub.tag = 1
        designLinkedIn.tag = 2
        mentorLinkedIn.tag = 3
        mentorGithub.tag = 4

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        devTitle.font = UIFont(name: DefaultAppFontNameUltraLight, size: AppCreditsTitleFontSize)
        designTitle.font = UIFont(name: DefaultAppFontNameUltraLight, size: AppCreditsTitleFontSize)
        mentorTitle.font = UIFont(name: DefaultAppFontNameUltraLight, size: AppCreditsTitleFontSize)

        devTitle.textAlignment = NSTextAlignment.Left
        designTitle.textAlignment = NSTextAlignment.Left
        mentorTitle.textAlignment = NSTextAlignment.Left

        devTitle.textColor = blueColor
        designTitle.textColor = pinkColor
        mentorTitle.textColor = greenColor

        devName.font = UIFont(name: DefaultAppFontNameLight, size: AppCreditsNameFontSize)
        designName.font = UIFont(name: DefaultAppFontNameLight, size: AppCreditsNameFontSize)
        mentorName.font = UIFont(name: DefaultAppFontNameLight, size: AppCreditsNameFontSize)

        devName.textColor = grayColor
        designName.textColor = grayColor
        mentorName.textColor = grayColor

        devName.textAlignment = NSTextAlignment.Left
        designName.textAlignment = NSTextAlignment.Left
        mentorName.textAlignment = NSTextAlignment.Left

        devLinkedIn.setImage(UIImage(named: "linkedIn.png"), forState: UIControlState.Normal)
        devLinkedIn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        devGithub.setImage(UIImage(named:"github.png"), forState: UIControlState.Normal)
        devGithub.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        devLinkedIn.contentMode = UIViewContentMode.ScaleAspectFit
        devGithub.contentMode = UIViewContentMode.ScaleAspectFit

        designLinkedIn.titleLabel?.text = ""
        designLinkedIn.setImage(UIImage(named: "linkedIn.png"), forState: UIControlState.Normal)
        designLinkedIn.contentMode = UIViewContentMode.ScaleAspectFit

        mentorLinkedIn.setImage(UIImage(named: "linkedIn.png"), forState: UIControlState.Normal)
        mentorLinkedIn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        mentorGithub.setImage(UIImage(named: "github.png"), forState: UIControlState.Normal)
        mentorGithub.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        mentorLinkedIn.contentMode = UIViewContentMode.ScaleAspectFit
        mentorGithub.contentMode = UIViewContentMode.ScaleAspectFit

        devLinkedIn.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        devGithub.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        designLinkedIn.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        mentorLinkedIn.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        mentorGithub.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)

        var info = NSBundle.mainBundle().infoDictionary!
        let versionStr = info["CFBundleShortVersionString"] as! String
        version.text = "V \(versionStr)"
        version.font = UIFont(name: DefaultAppFontNameUltraLight, size: 10)
        version.textAlignment = .Center
        version.textColor = grayColor

    }

    func buttonTapped(sender: UIButton) {
        let link = buttonLinks[sender.tag]
        if let externalURL = NSURL(string: link) {
            UIApplication.sharedApplication().openURL(externalURL)
        }
    }

}
