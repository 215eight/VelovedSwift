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
    
    func addElement(element: StageElement) -> StageLocation {
        let location = randomLocation()
        element.location = location
        
        let elementType = element.dynamicType.className()
        if var elementArray = elements[elementType] {
            elementArray.append(element)
            _elements[elementType] = elementArray
        }else {
            _elements[elementType] = [element]
        }
        
        return location
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
        if let existingSnake = doesElementExist(snake) as? Snake {
            if let obstacles  = elements[Obstacle.className()] {
                return obstacles.contains(snake as StageElement)
            }else {
                return false
            }
        }
        return false
    }
    
    func didSnakeEatAnApple(snake: Snake) -> Apple? {
        if let existingSnake = doesElementExist(snake) as? Snake {
            if let apples = elements[Apple.className()] {
                let snakeArray = [snake] as [StageElement]
                let eatenApples = apples.intersects(snakeArray)
                return eatenApples.last as? Apple
            }else {
                return nil
            }
        }
        return nil
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
    
    
    // MARK: Helper functions
    
    func randomLocation() -> StageLocation {
        let x = Int(arc4random_uniform(UInt32(size.width)))
        let y = Int(arc4random_uniform(UInt32(size.height)))
        var location = StageLocation(x: x, y: y)
        
        if contains(location) { location = randomLocation() }
        
        return location
    }
    
    func contains(location: StageLocation) -> Bool {
        
        var contains = false
        
        let allValues = elements.values.array
        for typeValues in allValues {
            contains = typeValues.map( { $0.location! } ).contains(location)
            if contains { break }
        }
        
        return contains
        
    }
    
    func doesElementExist(element: StageElement) -> StageElement? {
        
        let elementType = element.dynamicType.className()
        
        if let existingElements = elements[elementType] {
            let existingElement = [element].intersects(existingElements)
            if existingElement.count == 1 {
                return existingElement.last!
            }else {
                // "ERROR: InternalInconsistencyException. Element does no exist on stage"
                return nil
            }
        }else {
            // "ERROR: InternalInconsistencyException. No elements of type \(elementType) exist on stage"
            return nil
        }
    }
}

protocol StageDelegate: class {
    func randomLocations(postions: Int, direction: Direction?)
    func elementLocationDidChange(element: StageElement, inStage stage: Stage)
}