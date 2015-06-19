//
//  StageElement.swift
//  GameSwift
//
//  Created by eandrade21 on 3/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

private let concurrentStageElementQueueName = "com.partyland.StageElementQueue"

public class StageElement: NSObject, StageLocatable {

    private let stageElementQueue = dispatch_queue_create(concurrentStageElementQueueName,
        DISPATCH_QUEUE_CONCURRENT)

    private var _locations : [StageLocation]

    public var locations: [StageLocation] {
        get{
            var tempLocations = [StageLocation]()
            dispatch_sync(stageElementQueue) {
                tempLocations = self._locations
            }
            return tempLocations
        }
        set(newLocations) {
            dispatch_barrier_async(stageElementQueue) {
                self._locations = newLocations
            }
        }
    }

    func emptyLocations() {
        dispatch_barrier_async(stageElementQueue) {
            self._locations = [StageLocation]()
        }
    }

    public var elementID: String

    public class var elementName: String {
        return "StageElement"
    }
    
    init(locations: [StageLocation]) {
        _locations = locations
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
    func broadcastElementDidChangeDirectionEvent(element: StageElementDirectable)
    func broadcastElementDidMoveEvent(element: StageElement)
    func broadcastElementDidDeactivate(element: StageElement)
}