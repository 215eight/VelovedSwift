//
//  AppleConfigurator.swift
//  SnakeSwift
//
//  Created by eandrade21 on 5/11/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

struct AppleConfigurator {

    private let stage: Stage

    init(stage: Stage) {
        self.stage = stage
    }

    func configureApples(appleConfigMap: [String : AppleConfiguration]) -> [String : Apple]{

        var appleMap = [String : Apple]()

        for (peerName, appleConfig)  in appleConfigMap {
            var apple: Apple

            if peerName == MPCController.sharedMPCController.peerID.displayName {
                apple = AppleLocal(locations: appleConfig.locations, value: DefaultAppleValue)
            } else {
                apple = AppleRemote(locations: appleConfig.locations, value: DefaultAppleValue)
            }
            apple.delegate = stage
            stage.addElement(apple)
            // Apple element name used as key since only one apple is created
            // Change this key to something meaningful if at some point apples need to categorized
            appleMap[Apple.elementName] = apple
        }

        return appleMap
    }
}