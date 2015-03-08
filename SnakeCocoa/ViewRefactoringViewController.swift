//
//  ViewRefactoringViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 3/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class ViewRefactoringViewController: UIViewController {

    var bodyPartView: SnakeBodyPartView!
    var directions: [Direction] = [.Right, .Down, .Left, .Up]
    var timer: NSTimer!
    
    
    
    // MARK: Prototype
    override func viewDidLoad() {
        
        let center = CGPoint(x: 100, y: 150)
        let size = CGSize(width: 50, height: 50)
        let offset = CGPoint(x: 10, y: 10)
        let direction = Direction.Up
        
        // Create a view
        bodyPartView = SnakeBodyPartView(center: center, size: size, offset: offset, direction: direction)
        
        view.addSubview(bodyPartView)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "changeDir", userInfo: nil, repeats: true)
        
    }
    
    func changeDir() {
        if let direction = directions.first {
            println("Chang Dir")
            directions.removeAtIndex(0)
            bodyPartView.direction = direction
            bodyPartView.setNeedsDisplay()
            
        }else {
            timer.invalidate()
        }
    }
    
}
