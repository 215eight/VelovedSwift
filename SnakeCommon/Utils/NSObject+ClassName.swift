//
//  NSObject+ClassName.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

public extension NSObject {
    public class func getClassName() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}