//
//  iOS_FullBikeViewController.swift
//  VelovedGame
//
//  Created by eandrade21 on 6/30/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

class iOS_FullBikeViewController: iOS_CustomViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.hidden = true
        self.edgesForExtendedLayout = UIRectEdge.None

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let bikeFullView = BikeFullView(frame: view.bounds)
        view.addSubview(bikeFullView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
