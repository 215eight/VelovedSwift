//
//  NewSnakeView.swift
//  SnakeSwift
//
//  Created by PartyMan on 3/8/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class NewSnakeView: UIView {
    
    let gridUnits: CGFloat = 1.0
    let snakeOffset = CGPoint(x: 0, y: 0)
    var scaleFactor: CGFloat = 10.0
    
    func drawSnake(snake: Snake) {
        // Clean all subviews
        self.subviews.map(){ $0.removeFromSuperview() }
        
        // Draw new views
        for bodyPart in snake.snakeBody {
            let snakeBodyPartView = SnakeBodyPartView(bodyPart: bodyPart, gridUnits: gridUnits, scaleFactor: scaleFactor, offset: snakeOffset)
            self.addSubview(snakeBodyPartView)
        }
        
    }

}
