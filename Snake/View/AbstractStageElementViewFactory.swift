//
//  AbstractStageElementViewFactory.swift
//  SnakeSwift
//
//  Created by eandrade on 4/14/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

enum StageElementViewFactoryType {
    case OSX_StageElementViewFactory
    case iOS_StageElementViewFactory
}

struct AbstractStageElementViewFactory {

    static func getStageElementViewFactory(type: StageElementViewFactoryType) -> ConcreteStageElementViewFactory {
        switch type {
        case .OSX_StageElementViewFactory:
            return OSX_StageElementViewFactory()
        case .iOS_StageElementViewFactory:
            return OSX_StageElementViewFactory()
        }
    }
    
}