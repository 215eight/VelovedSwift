//
//  NSObject+ClassName.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/16/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

extension NSObject {
    class func className() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
}