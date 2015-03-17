//
//  SnakeView.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SnakeView: UIView {
    
    // Mark: Properties
    
    var bodyPartLogicalSize: CGFloat = 1.0
    var scaleFactor: CGFloat = 10.0
    var viewOffset = CGPoint(x: 0, y: 0)
    
    var rightSwipeGS: UISwipeGestureRecognizer!
    var leftSwipeGS: UISwipeGestureRecognizer!
    var upSwipeGS: UISwipeGestureRecognizer!
    var downSwipeGS: UISwipeGestureRecognizer!
    
    weak var delegate: SnakeViewDelegate?
    
    
    // MARK: Initializer
    
    init(frame: CGRect, bodyPartLogicalSize: CGFloat, scaleFactor: CGFloat, viewOffset: CGPoint) {
        
        self.bodyPartLogicalSize = bodyPartLogicalSize
        self.scaleFactor = scaleFactor
        self.viewOffset = viewOffset
        
        super.init(frame: frame)
        
        setUpGestureRecognizers()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpGestureRecognizers() {
        
        // Right Direction
        rightSwipeGS = UISwipeGestureRecognizer(target: self, action: "steerSnake:")
        rightSwipeGS.numberOfTouchesRequired = 1
        rightSwipeGS.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(rightSwipeGS)
        
        // Left Direction
        leftSwipeGS = UISwipeGestureRecognizer(target: self, action: "steerSnake:")
        leftSwipeGS.numberOfTouchesRequired = 1
        leftSwipeGS.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(leftSwipeGS)
        
        // Up Direction
        upSwipeGS = UISwipeGestureRecognizer(target: self, action: "steerSnake:")
        upSwipeGS.numberOfTouchesRequired = 1
        upSwipeGS.direction = UISwipeGestureRecognizerDirection.Up
        self.addGestureRecognizer(upSwipeGS)
        
        // Down Direction
        downSwipeGS = UISwipeGestureRecognizer(target: self, action: "steerSnake:")
        downSwipeGS.numberOfTouchesRequired = 1
        downSwipeGS.direction = UISwipeGestureRecognizerDirection.Down
        self.addGestureRecognizer(downSwipeGS)
        
    }
    
    
    // MARK: Instance Methods
    
    func drawSnake(snake: Snake) {
        // Clean all subviews
        self.subviews.map(){ $0.removeFromSuperview() }
        
        // Draw new views
//        for snakeBodyPart in snake.snakeBody {
//            let snakeBodyPartView = SnakeBodyPartView(bodyPart: snakeBodyPart,
//                gridUnits: bodyPartLogicalSize,
//                scaleFactor: scaleFactor,
//                offset: viewOffset)
//            self.addSubview(snakeBodyPartView)
        }
        
    }
    
//    func snakeHeadRect(snake: Snake) -> CGRect {
//        let snakeHead = SnakeBodyPartView(bodyPart: snake.snakeHead,
//            gridUnits: bodyPartLogicalSize,
//            scaleFactor: scaleFactor,
//            offset: viewOffset)
//        
//        return snakeHead.frame
//    }
    
//    func bodyPartsRects(snake: Snake) -> [CGRect] {
//        var bodyPartsRect = snake.snakeBody.map() { (bodyPart: SnakeBodyPart) -> CGRect in
//            return SnakeBodyPartView(bodyPart: bodyPart,
//                gridUnits: self.bodyPartLogicalSize,
//                scaleFactor: self.scaleFactor,
//                offset: self.viewOffset).frame
//        }
//
//       // Remove head
//        bodyPartsRect.removeAtIndex(0)
//
//        return bodyPartsRect
//    }
//    
//    // MARK: Action methods
//    
//    func steerSnake(gestureRecognizer: UISwipeGestureRecognizer) {
//        if let _delegate = delegate {
//            // Detect direction
//            let direction = gestureRecognizer.direction
//            
//            if gestureRecognizer.direction == rightSwipeGS.direction {
//                _delegate.steerSnake(Direction.Right)
//            }
//            
//            if gestureRecognizer.direction == leftSwipeGS.direction {
//                _delegate.steerSnake(Direction.Left)
//            }
//            
//            if gestureRecognizer.direction == upSwipeGS.direction {
//                _delegate.steerSnake(Direction.Up)
//            }
//            
//            if gestureRecognizer.direction == downSwipeGS.direction {
//                _delegate.steerSnake(Direction.Down)
//            }
//        }
//    }
//}

protocol SnakeViewDelegate : class {
    
    func steerSnake(direction: Direction)
    
}
