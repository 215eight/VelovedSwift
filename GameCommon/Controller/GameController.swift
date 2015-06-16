//
//  GameController.swift
//  GameSwift
//
//  Created by eandrade21 on 4/9/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//
import Foundation

public protocol GameViewController {
    func setUpView()
    func drawViews() //Investigate
    func drawElement(element: StageElement)
    func destroy()
}

public enum GameMode {
    case SinglePlayer
    case MultiPlayer
}

public class GameController: NSObject {

    public var viewController: GameViewController?

    public var stage: Stage!
    var playerController: PlayerController!

    public func startGame() {
        assertionFailure("This is an abstract method that must be overriden by a subclass")
    }

    public func setUpModel() {
        assertionFailure("This is an absract method that must be overridden by a subclass")
    }

    func setUpView() {
        viewController?.setUpView()
    }

    func animateStage() {
        playerController.isProcessingKeyInput = true
        stage.animate()
    }

    func stopAnimatingStage() {
        playerController.isProcessingKeyInput = false
        stage.stopAnimating()
    }

    public func stopGame() {
        playerController?.isProcessingKeyInput = false
        destroyModel()
        destroyView()
    }

    public func destroyModel() {
        stage?.destroy()
        stage = nil
    }

    public func destroyView() {
        viewController?.destroy()
    }


    func restartGame() {
        destroyModel()
        dispatch_async(dispatch_get_main_queue()) {
            self.destroyView()
            self.startGame()
        }
    }

    public func processKeyInput(key: String, transform: StageViewTransform) -> Direction?{
        if let keyDirection = playerController.getDirectionForKey(key) {
            var trxDirection = transform.getDirection(keyDirection)
            playerController.processKeyInput(key, direction: trxDirection)
            return trxDirection
        }
        return nil
    }

    public func processSwipe(direction: Direction) {
        playerController.processSwipe(direction)
    }

    public func processPauseOrResumeGame() {
        pauseOrResumeGame()
    }

    func pauseOrResumeGame() {
        if stage.isAnimating() {
            stage.stopAnimating()
        }else {
            stage.animate()
        }
    }
}