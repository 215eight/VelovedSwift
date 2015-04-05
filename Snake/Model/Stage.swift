//
//  Stage.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

private let _sharedStage = Stage()

class Stage: NSObject, StageElementDelegate {

    // MARK: Singleton initializer
    
    class var sharedStage: Stage {
        return _sharedStage
    }
    
    // MARK: Properties
    
    private var size: StageSize!
    
    private var _elements = [String: [StageElement]]()
    
    var elements: [String: [StageElement]] {
        return _elements
    }
    
    func addElement(element: StageElement) {
        let elementType = element.dynamicType.className()
        if var elementArray = elements[elementType] {
            elementArray.append(element)
            _elements[elementType] = elementArray
        }else {
            _elements[elementType] = [element]
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
        if doesElementExist(snake) {
            if let obstacles  = elements[Obstacle.className()] {
                return intersects(snake.locations, obstacles.map(){ $0.locations } )
            }else {
                return false
            }
        } else {
            assertionFailure("ERROR: Snake does not exist in the stage")
        }
    }
    
    func didSnakeCrashWithAnObstacle(snake: Snake) -> Bool {
        return true
    }
    
    func didSnakeCrashWithOtherSnake(snake: Snake) -> Bool {
        if doesElementExist(snake) {
            let snakes = elements[Snake.className()]
            let otherSnakes  = snakes!.filter() {
                $0.elementID != snake.elementID
            }
                
            if otherSnakes.isEmpty { return false }
            
            let otherSnakesLocations = otherSnakes.map( {$0.locations} )

            return intersects(snake.head, otherSnakesLocations)
            
        } else {
            assertionFailure("ERROR: Sanke does not exist in the stage")
        }
    }
    func didSnakeEatItself(snake: Snake) -> Bool {
        return intersects(snake.head, [snake.body])
    }
    
    func didSnakeEatAnApple(snake: Snake) -> Apple? {
        if doesElementExist(snake) {
            if let apples = elements[Apple.className()] {
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
    
    func animate() {
        
        if let apples = elements[Apple.className()] as? [Apple] {
            apples.map() { $0.animate() }
        }
        
        if let snakes = elements[Snake.className()] as? [Snake] {
            snakes.map() { $0.animate() }
        }
    }
    
    func destroy() {
        delegate = nil
        
        // Destroy apples
        if let apples = elements[Apple.className()] as? [Apple] {
            apples.map(){ $0.destroy() }
        }
        
        // Kill snakes
        if let snakes = elements[Snake.className()] as? [Snake] {
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
            locations.append(leadingPos.destinationLocation(direction.inverse))
            leadingPos = locations.last!
        }
        
        let intersects = !locations.reduce(true) { (lhs: Bool, rhs: StageLocation) in
            lhs && !self.stageContains(rhs) }
        
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
        if delegate != nil {
            delegate!.elementLocationDidChange(element, inStage: self)
        }
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
        
        let elementType = element.dynamicType.className()
        
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
}