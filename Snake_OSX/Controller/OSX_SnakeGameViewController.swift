
//
//  OSX_SankeGameViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/7/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit
import SnakeCommon

class OSX_SnakeGameViewController: NSViewController {

    var snakeGameController: SnakeGameController!
    var stageView: OSX_StageView!
    weak var windowContainer: OSX_MainWindowController?

    init?(gameMode: SnakeGameMode) {
        super.init(nibName: "OSX_SnakeGameViewController", bundle: nil)

        MPCController.sharedMPCController.delegate = self

        switch gameMode {
        case .SinglePlayer:
            snakeGameController = SinglePlayerSnakeGameController(viewController: self)
        case .MultiPlayerMaster:
            snakeGameController = MultiplayerMasterSnakeGameController(viewController: self)
        case .MultiplayerSlave:
            snakeGameController = MultiplayerSlaveSnakeGameController(viewController: self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.frame = OSX_WindowResizer.resizeWindowProportionalToScreenResolution(0.5)!

        snakeGameController.startGame()
    }

    override func viewWillDisappear() {
        windowContainer?.snakeGame = nil
        windowContainer = nil
    }
}

extension OSX_SnakeGameViewController: SnakeViewController {

    func setUpView() {
        stageView = OSX_StageView(frame: view.bounds)
        stageView.becomeFirstResponder()
        stageView.delegate = self
        view.addSubview(stageView)
        drawViews()
    }

    func drawViews() {
        for (_, elementCollection) in snakeGameController.stage.elements {
            for element in elementCollection {
                drawElement(element)
            }
        }
    }

    func drawElement(element: StageElement) {
        dispatch_async(dispatch_get_main_queue()) {
            self.stageView.drawElement(element)
        }
    }

    func destroy() {
        stageView.resignFirstResponder()
        stageView.delegate = nil
        stageView.removeFromSuperview()
        stageView = nil
    }

    func showModalMessage() {
        stageView.showModalMessage()
    }
}


extension OSX_SnakeGameViewController: InputViewDelegate {
    func processKeyInput(key: String, transform: StageViewTransform) {
        snakeGameController.processKeyInput(key, transform: transform)
    }
}

extension OSX_SnakeGameViewController: MPCControllerDelegate {
    
    func didReceiveMessage(msg: MPCMessage) {
        switch msg.event {
        case .SetUpApples:
            setUpApples(msg)
        case .SetUpSnakes:
            setUpSnakes(msg)
        case .ScheduleGame:
            scheduleGameStart(msg)
        case .SnakeDidChangeDirection:
            updateRemoteSnakeDirection(msg)
        case .AppleDidChangeLocation:
            updateRemoteAppleLocations(msg)
        default:
            break
        }
    }

    func setUpApples(msg: MPCMessage) {
        if let appleConfigMap = msg.body as? [String : AppleConfiguration] {
            snakeGameController.setUpApples(appleConfigMap)
        }
        drawViews()
    }

    func setUpSnakes(msg: MPCMessage) {
        if let snakeConfigMap = msg.body as? [String : SnakeConfiguration] {
            snakeGameController.setUpSnakes(snakeConfigMap)
        }
        drawViews()
    }

    func scheduleGameStart(msg: MPCMessage) {
        if let body = msg.body {
            if let gameStartDate = body[MPCMessageKey.GameStartDate.rawValue] as? String {
                snakeGameController.scheduleGameStart(gameStartDate)
            }
        }
    }

    func updateRemoteSnakeDirection(msg: MPCMessage) {
        if let body = msg.body {
            if let directionDesc = body[MPCMessageKey.SnakeDirection.rawValue] as? String {
                let direction = Direction(rawValue: UInt8(directionDesc.toInt()!))!
                snakeGameController.updateRemoteSnakeDirection(msg.sender, newDirection: direction)
            }
        }
    }

    func updateRemoteAppleLocations(msg: MPCMessage) {
        if let body = msg.body {
            if let locationsSerialiazable = body[MPCMessageKey.Locations.rawValue] as? [StageLocationSerializable] {
                let locations = locationsSerialiazable.map() {
                    StageLocation(x: Int($0.x), y: Int($0.y))
                }
                snakeGameController.updateRemoteAppleLocations(Apple.elementName, locations: locations)
            }
        }
    }
}