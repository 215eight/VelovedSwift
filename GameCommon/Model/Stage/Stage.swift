//
//  Stage.swift
//  VelovedGame
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

private let _sharedStage = Stage()
private let concurrentStageQueueName = "com.partyland.StageQueue"

public class Stage: NSObject {

    // MARK: Singleton initializer
    
    class var sharedStage: Stage {
        return _sharedStage
    }

    private override init() {
        super.init()
    }
    
    // MARK: Properties

    private let stageQueue = dispatch_queue_create(concurrentStageQueueName, DISPATCH_QUEUE_CONCURRENT)

    private var size: StageSize!
    
    private var _elements = [String: [StageElement]]()
    
    public var elements: [String: [StageElement]] {
        var tempElements = [String: [StageElement]]()
        dispatch_sync(stageQueue) {
            tempElements = self._elements
        }
        return tempElements
    }
    
    func addElement(element: StageElement) {
        dispatch_barrier_async(stageQueue) {
            let elementType = element.dynamicType.elementName
            if var elementArray = self._elements[elementType] {
                elementArray.append(element)
                self._elements[elementType] = elementArray
            }else {
                self._elements[elementType] = [element]
            }
        }
    }

    func removeElementsOfType(elementType: String) {
        dispatch_barrier_async(stageQueue) {
            self._elements[elementType] = nil
        }
    }
    
    var configurator: StageConfigurator! {
        didSet{
            size = configurator.size
            _elements = configurator.elements
        }
    }
    
    weak var delegate: StageDelegate!
    private var animating = false

    // MARK: Instance methods

    func didPlayerCrash(player: Player) -> Bool {
        return didPlayerCrashWithAnObstacle(player) || didPlayerCrashWithOtherPlayer(player)
    }
    
    func didPlayerCrashWithAnObstacle(player: Player) -> Bool {
        if doesElementExist(player) {
            if let obstacles  = elements[Obstacle.elementName] {
                return intersects(player.locations, obstacles.map(){ $0.locations } )
            }else {
                return false
            }
        } else {
            assertionFailure("ERROR: Player does not exist in the stage")
        }
    }
    
    func didPlayerCrashWithOtherPlayer(player: Player) -> Bool {
        if doesElementExist(player) {
            let players = elements[Player.elementName]
            let otherPlayers  = players!.filter() {
                $0.elementID != player.elementID
            }
                
            if otherPlayers.isEmpty { return false }
            
            let otherPlayersLocations = otherPlayers.map( {$0.locations} )

            return intersects(player.head, otherPlayersLocations)
            
        } else {
            assertionFailure("ERROR: Player does not exist in the stage")
        }
    }
    
    func didPlayerEatItself(player: Player) -> Bool {
        return intersects(player.head, [player.body])
    }
    
    func didPlayerSecureTarget(player: Player) -> Target? {
        if doesElementExist(player) {
            if let targets = elements[Target.elementName] {
                let securedTargets = intersects(targets, player)
                if securedTargets.count > 1 {
                    assertionFailure("A player cannot hit more than one target at a time")
                }
                return securedTargets.last as? Target
            }else {
                return nil
            }
        } else {
            assertionFailure("ERROR: Target does not exist in the stage")
        }
    }
    
    func numberOfActivePlayers() -> Int {
        if let players = elements[Player.elementName] as? [Player] {
            let playersActive = players.filter( { !$0.locations.isEmpty } )
            return playersActive.count
        }
        return 0
    }
    
    func animate() {

        animating = true
        animateTargets()
        animatePlayers()
    }

    func isAnimating() -> Bool {
        return animating
    }

    private func animateTargets() {
        if let targets = elements[Target.elementName] as? [Target] {
            targets.map() { $0.animate() }
        }
    }

    private func animatePlayers() {
        if let players = elements[Player.elementName] as? [Player] {
            players.map() { $0.animate() }
        }
    }

    func stopAnimating() {

        animating = false
        if let targets = elements[Target.elementName] as? [Target] {
            targets.map() { $0.invalidateTimer() }
        }

        if let players = elements[Player.elementName] as? [Player] {
            players.map() { $0.invalidateMoveTimer() }
        }
    }
    
    func destroy() {

        // Destroy targets
        if let targets = elements[Target.elementName] as? [Target] {
            targets.map(){ $0.destroy() }
        }
        
        // Deactivate players
        if let players = elements[Player.elementName] as? [Player] {
            players.map(){ $0.deactivate() }
        }
        
        _elements.removeAll(keepCapacity: false)
        delegate = nil
    }
    
    // MARK: Helper functions
    
    func stageContains(location: StageLocation) -> Bool {
        
        var isInStage = false
        let allElementTypeValues = _elements.values.array
        for elementTypeValues in allElementTypeValues {
            let elementTypeLocations = elementTypeValues.map( { $0.locations } )
            isInStage = intersects(location, elementTypeLocations)
            if isInStage { break }
        }
        return isInStage
    }
   
    func doesElementExist(element: StageElement) -> Bool {
        
        let elementType = element.dynamicType.elementName
        if let elements = elements[elementType] {
            let existingElement = elements.filter( {$0.elementID == element.elementID} )
            
            if existingElement.count > 1 {
                assertionFailure("ERROR: InternalIncosistency. Two objects with the same UUID exist are part of the stage")
            }
            
            if existingElement.isEmpty{
                return false
            }else {
                return true
            }
        }
        return false
    }
}

extension Stage: StageElementDelegate {

    func randomLocations(positions: Int) -> [StageLocation] {
        if positions < 0 || positions != 1 {
            assertionFailure("Positions must be equal to 1")
        }
        let x = Int(arc4random_uniform(UInt32(size.width)))
        let y = Int(arc4random_uniform(UInt32(size.height)))
        var location = StageLocation(x: x, y: y)

        if stageContains(location) { location = randomLocations(1).first! }

        return [location]
    }


    func randomLocations(positions: Int, direction: Direction) -> [StageLocation] {

        if positions < 0 {
            assertionFailure("Positions must be positive")
        }

        if positions >= min(size.width, size.height) {
            assertionFailure("Positions should not exceed the shorter side of the stage")
        }

        var locations = randomLocations(1)
        var leadingPos = locations.last!

        for var i = 1; i<positions; i++ {
            locations.append(leadingPos.destinationLocation(Direction.reversedDirection(direction)))
            leadingPos = locations.last!
        }

        let intersects = !locations.reduce(true) { (lhs: Bool, rhs: StageLocation) in
            lhs && !self.stageContains(rhs)
        }

        if intersects {
            locations = randomLocations(positions, direction: direction)
        }

        return locations
    }

    func destinationLocation(location: StageLocation, direction: Direction) -> StageLocation {

        // TODO: Check if the specified location in a loop hole
        // If yes, then return the destination location of the loop hole

        return location.destinationLocation(direction)

    }


    func broadcastElementDidChangeDirectionEvent(element: StageElementDirectable){
        delegate?.broadcastElementDidChangeDirectionEvent(element)
    }

    func broadcastElementDidMoveEvent(element: StageElement) {
        delegate?.broadcastElementDidMoveEvent(element)
    }

    func elementLocationDidChange(element: StageElement) {
        delegate?.elementLocationDidChange(element, inStage: self)
        delegate?.validateGameLogicUsingElement(element, inStage: self)
    }
}

protocol StageDelegate: class {
    func broadcastElementDidChangeDirectionEvent(element: StageElementDirectable)
    func broadcastElementDidMoveEvent(element: StageElement)
    func elementLocationDidChange(element: StageElement, inStage stage: Stage)
    func validateGameLogicUsingElement(element: StageElement, inStage stage: Stage)
}