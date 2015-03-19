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

    
    // MARK: Apple delegate methods
    func updateAppleLocation(apple: Apple) -> StageLocation {
        let location = randomLocation()
        
        var exists = false
        if let appleElements = elements[Apple.className()] {
            for appleElement in appleElements as [Apple] {
                if apple == appleElement {
                    appleElement.location = location
                    exists = true
                    break
                }
            }
            
            if exists {
                return location
            }else {
                assertionFailure("InternalInconsistencyException. Trying to update an Apple that does not exist")
            }
        }else {
            assertionFailure("InternalInconsistencyException. No apples previously added to the stage")
        }
    }
    
    // MARK: Snake delegate methods
    func moveSnake(snake: Snake) -> StageLocation? {
        
        if let existingSnake = doesElementExist(snake) as? Snake {
            let location = existingSnake.location!.destinationLocation(existingSnake.direction)
            existingSnake.location = location
            return location
        }
        return nil
    }
}