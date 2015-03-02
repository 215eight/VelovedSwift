//
//  SnakeGameController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 2/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation

class SnakeGameController {
    
    //Properties
    let snakeView : SnakeView
    var stage : Stage
    var snake : Snake
    
    enum Collision {
        case Crash, Apple, None
    }
    
    enum MenuItem : String {
        case StartGameWithWalls = "Start game (With Walls)"
        case StartGameWithoutWalls = "Start game (Wihtout Walls)"
        case QuitGame = "Quit Game"
    }
    
    //Methods
    init() {
        
        //Init SnakeView first as it mandates the size of the stage depending on the size of the terminal
        //This is due to the limitation of not having found an easy way to resize the terminal
        self.snakeView = SnakeView()
        self.stage = Stage(height: snakeView.stageHeight, width: snakeView.stageWidth, hasWalls: true)
        self.snake = Snake(originy: stage.height/3, originx: stage.width/3, height: stage.height/3, width: stage.width/3)
    }
    
    func startGame() {
                
        //Display init menu
        displayInitMenu()
        
        
    }
    
    func displayInitMenu() {
        
        var menuItems : [String] = [ MenuItem.StartGameWithWalls.rawValue, MenuItem.StartGameWithoutWalls.rawValue, MenuItem.QuitGame.rawValue]
        let menu : UnsafeMutablePointer<MENU> = snakeView.printMenu(menuItems)
            
        //Ask for user input to start the game
        var key : Int32 = 0
        var waitForInput = true
        while waitForInput {
            
            key = wgetch(menu_win(menu))
            
            switch key {
                
            case KEY_DOWN:
                menu_driver(menu, KEY_MAX+4) //REQ_DOWN_ITEM
                
            case KEY_UP:
                menu_driver(menu, KEY_MAX+3) //REQ_UP_ITEM
                
            case Int32(CharacterUnicodeValue(" ")):
                waitForInput = false
                
            case Int32(CharacterUnicodeValue("q")):
                menuExitProgram(menu)
                
            default:
                break
            }
        }
        processMenu(menu)
    
    }
    
    func processMenu(menu:UnsafeMutablePointer<MENU>) {
        
        let menuNotMutable = UnsafePointer<MENU>(menu)
        var currentMenuItem = current_item(menuNotMutable)
        var currentItemName : String? = String.fromCString(item_name(currentMenuItem))
        
        if let name = currentItemName {
            
            switch name {
            
            case "Start game (With Walls)":
                snakeView.destroyMenu(menu)
                startPlaying(hasWalls: true)
            case "Start game (Wihtout Walls)":
                snakeView.destroyMenu(menu)
                startPlaying(hasWalls: false)
            default:
                menuExitProgram(menu)
            }
        }else{
            precondition(false, "There was no menu item selected")
        }
    }
    
    func menuExitProgram(menu:UnsafeMutablePointer<MENU>) {
        
        snakeView.destroyMenu(menu)
        exitProgram()
    }
    
    func exitProgram() {
        
        snakeView.destroyStage();
        exit(EX_OK)
        
    }
    
    func startPlaying(#hasWalls: Bool) {
        
        stage = Stage(height: snakeView.stageHeight, width: snakeView.stageWidth, hasWalls: hasWalls)
        snake = Snake(originy: stage.height/3, originx: stage.width/3, height: stage.height/3, width: stage.width/3)
        
        snakeView.printStage(stage)
        snakeView.printSnake(snake)
        snakeView.printApple(stage.appleLocation)
        
        mainLoop()
        
    }
    
    func mainLoop(){
        
        var key : Int32 = 0
        var waitForInput = true
        while waitForInput {
            
            key = wgetch(snakeView.stageWin)
        
            
            switch key {
                
            case KEY_DOWN:
                if (snake.direction == Direction.right || snake.direction == Direction.left) { snake.direction = Direction.down }
            case KEY_UP:
                if (snake.direction == Direction.right || snake.direction == Direction.left) { snake.direction = Direction.up }
            case KEY_RIGHT:
                if (snake.direction == Direction.up || snake.direction == Direction.down) { snake.direction = Direction.right }
            case KEY_LEFT:
                if (snake.direction == Direction.up || snake.direction == Direction.down) { snake.direction = Direction.left }
            case Int32(CharacterUnicodeValue("q")):
                exitProgram()
            default:
                break
            }
    
            //move
            snake.move(self.stage)
            
            //check for collisions
            let collision = checkCollisions()
            
            switch collision {
                
            case Collision.Crash:
                
                waitForInput = false
                
            case Collision.Apple:
                
                snake.grow()
                stage.generateRandomApple()
                
            case Collision.None:
                break
            }
                
                
            snakeView.printApple(stage.appleLocation)
            snakeView.printSnake(snake)
            usleep(snake.speed)
            
        }
        
        //If made it out of the mainLoop it means there was a Collision.Crash
        snakeView.cleanStage()
        startGame()
    }
    
    func checkCollisions() -> Collision {
        
        //Check for apple collision
        if checkAppleCollision() { return Collision.Apple }
        
        if checkCrashCollision() { return Collision.Crash }
        
        return Collision.None
    }
    
    func checkAppleCollision() -> Bool {
        
        return snake.body[0] == stage.appleLocation
        
    }
    
    func checkCrashCollision() -> Bool {
        
        if stage.hasWalls {
            return checkBordersCollision() || checkSnakeCollision()
        }else{
            return checkSnakeCollision()
        }
    }
    
    func checkBordersCollision() -> Bool {
        
        var origin = snake.body[0]
        
        //Check top and bottom wall
        for index in 0 ... stage.width {
            if (origin == Point(x: index, y: 0) || origin == Point(x: index, y: stage.height-1)) { return true }
        }
        
        //Check right and left wall
        for index in 0 ... stage.height {
            if (origin == Point(x:0, y: index) || (origin == Point(x:stage.width-1, y: index))) { return true }
        }
        
        return false;
    }
    
    func checkSnakeCollision() -> Bool {
        
        var origin = snake.body[0]
        
        for index in 1 ..< snake.body.count{
            if origin == snake.body[index] { return true }
        }
        
        return false
        
    }
}
