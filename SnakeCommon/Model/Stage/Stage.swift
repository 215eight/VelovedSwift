//
//  Stage.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

private let _sharedStage = Stage()
private let concurrentStageQueueName = "com.partyland.StageQueue"

public class Stage: NSObject, StageElementDelegate {

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
   
    // MARK: Instance methods
    func didSnakeCrash(snake: Snake) -> Bool {
        return didSnakeCrashWithAnObstacle(snake) || didSnakeCrashWithOtherSnake(snake)
    }
    
    func didSnakeCrashWithAnObstacle(snake: Snake) -> Bool {
        if doesElementExist(snake) {
            if let obstacles  = elements[Obstacle.elementName] {
                return intersects(snake.locations, obstacles.map(){ $0.locations } )
            }else {
                return false
            }
        } else {
            assertionFailure("ERROR: Snake does not exist in the stage")
        }
    }
    
    func didSnakeCrashWithOtherSnake(snake: Snake) -> Bool {
        if doesElementExist(snake) {
            let snakes = elements[Snake.elementName]
            let otherSnakes  = snakes!.filter() {
                $0.elementID != snake.elementID
            }
                
            if otherSnakes.isEmpty { return false }
            
            let otherSnakesLocations = otherSnakes.map( {$0.locations} )

            return intersects(snake.head, otherSnakesLocations)
            
        } else {
            assertionFailure("ERROR: Snake does not exist in the stage")
        }
    }
    
    func didSnakeEatItself(snake: Snake) -> Bool {
        return intersects(snake.head, [snake.body])
    }
    
    func didSnakeEatAnApple(snake: Snake) -> Apple? {
        if doesElementExist(snake) {
            if let apples = elements[Apple.elementName] {
                let eatenApples = intersects(apples, snake)
                if eatenApples.count > 1 {
                    assertionFailure("A snake cannot eat two apples at the same time")
                }
                return eatenApples.last as? Apple
            }else {
                return nil
            }
        } else {
            assertionFailure("ERROR: Snake does not exist in the stage")
        }
    }
    
    func snakesAlive() -> Int {
        if let snakes = elements[Snake.elementName] as? [Snake] {
            let snakesAlive = snakes.filter( { !$0.locations.isEmpty } )
            return snakesAlive.count
        }
        return 0
    }
    
    func animate() {
        
        if let apples = elements[Apple.elementName] as? [Apple] {
            apples.map() { $0.animate() }
        }
        
        if let snakes = elements[Snake.elementName] as? [Snake] {
            snakes.map() { $0.animate() }
        }
    }
    
    func destroy() {
        delegate = nil
        
        // Destroy apples
        if let apples = elements[Apple.elementName] as? [Apple] {
            apples.map(){ $0.destroy() }
        }
        
        // Kill snakes
        if let snakes = elements[Snake.elementName] as? [Snake] {
            snakes.map(){ $0.kill() }
        }
        
        _elements.removeAll(keepCapacity: false)
    }
    
    
    // MARK: StageElementDelegate methods
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
    
    func elementLocationDidChange(element: StageElement) {

        delegate?.elementLocationDidChange(element, inStage: self)
        delegate?.validateGameLogicUsingElement(element, inStage: self)
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

protocol StageDelegate: class {
    func elementLocationDidChange(element: StageElement, inStage stage: Stage)
    func validateGameLogicUsingElement(element: StageElement, inStage stage: Stage)
}