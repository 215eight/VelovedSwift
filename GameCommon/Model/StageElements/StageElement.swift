//
//  StageElement.swift
//  GameSwift
//
//  Created by eandrade21 on 3/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public class StageElement: NSObject, StageLocatable {
    
    public var locations: [StageLocation]
    var elementID: String

    public class var elementName: String {
        return "StageElement"
    }
    
    init(locations: [StageLocation]) {
        self.locations = locations
        elementID = NSUUID().UUIDString
        super.init()
    }
    
    convenience override init() {
        let zeroLocation = StageLocation(x: 0, y: 0)
        self.init(locations: [zeroLocation])
    }

    func getStageElementVector() -> StageElementVector {
        return StageElementVector(locations: locations, direction: nil)
    }

}

extension StageElement: Equatable {}

extension StageElement: StageLocationDescription {
    var locationDesc: String {
        return "-"
    }
}

public func ==(left: StageElement, right: StageElement) -> Bool {
    return left.locations == right.locations
}

public func !=(left: StageElement, right: StageElement) -> Bool {
    return !(left == right)
}

protocol StageElementDelegate: class {
    func randomLocations(positions: Int) -> [StageLocation]
    func randomLocations(positions: Int, direction: Direction) -> [StageLocation]
    func destinationLocation(location: StageLocation, direction: Direction) -> StageLocation
    func elementLocationDidChange(element: StageElement)
    func broadcastElementDidMoveEvent(element: StageElement)
}