//
//  Stage.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/13/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class Stage: NSObject, AppleDelegate, SnakeDelegate {
    
    // MARK: Properties
    var size: StageSize
    var elements: [String: [StageElement]]
    weak var delegate: StageDelegate!
   
    init(configurator: StageConfigurator) {
        size = configurator.size
        elements = configurator.elements
    }
    
    func randomLocation() -> StageLocation {
        let x = Int(arc4random_uniform(UInt32(size.width)))
        let y = Int(arc4random_uniform(UInt32(size.height)))
        var location = StageLocation(x: x, y: y)
        
        if contains(location) { location = randomLocation() }
        
        return location
    }
    
    func addElement(element: StageElement) -> StageLocation {
        let location = randomLocation()
        element.location = location
        
        let elementType = element.dynamicType.className()
        if var elementArray = elements[elementType] {
            elementArray.append(element)
            elements[elementType] = elementArray
        }else {
            elements[elementType] = [element]
        }
        
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
        
        elements.removeAll(keepCapacity: false)
    }
    
    // MARK: Apple delegate methods
    func updateAppleLocation(apple: Apple) -> StageLocation? {
        
        if let existingApple = doesElementExist(apple) as? Apple {
            let location = randomLocation()
            existingApple.location = location
            
            if let _delegate = delegate {
                _delegate.elementLocationDidChange(apple, inStage: self)
            }
            
            return location
        }
        return nil
    }
    
    // MARK: Snake delegate methods
    func moveSnake(snake: Snake) -> StageLocation? {
        
        if let existingSnake = doesElementExist(snake) as? Snake {
            let location = existingSnake.location!.destinationLocation(existingSnake.direction)
            existingSnake.location = location
            
            if let _delegate = delegate {
                _delegate.elementLocationDidChange(snake, inStage: self)
            }
            
            return location
        }
        return nil
    }
}

protocol StageDelegate: class {
    func elementLocationDidChange(element: StageElement, inStage stage: Stage)
}