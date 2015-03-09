//
//  ViewRefactoringViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 3/6/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class ViewRefactoringViewController: UIViewController {

    var snake : Snake!
    @IBOutlet var snakeView: NewSnakeView!
    
    override func loadView() {
        super.loadView()
        
        // Create a snake
        snake = Snake(xLowerBound: 0, xUpperBound: 40, yLowerBound: 0, yUpperBound: 70)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        snakeView.drawSnake(snake)
    }
}
